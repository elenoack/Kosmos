//
//  GameViewController.swift
//  Kosmos
//
//  Created by mac on 19.11.21.
//

import UIKit
import Foundation

class GameViewController: UIViewController {
    // MARK: - Properties
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var isPaused = true
    var namePlayer = UILabel()
    private let defaults = UserDefaultsStorage()
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var litleMeteoriteImage: UIImageView!
    
    var background = UIImageView(image: UIImage(named: "Background"))
    var background2 = UIImageView(image: UIImage(named: "Background"))
    
    private let closeButton = UIButton(title: NSLocalizedString("menu", comment: ""),font: UIFont(name: "UsuallyfontRegular", size: 24), color: .red)
    
    var shipImage = UIImageView(image: UIImage(named: "Ship"))
    let shipView = UIView()
    
    private var lastShipViewOriginX = CGFloat.zero
    private var lastShipViewOriginY = CGFloat.zero
    
    var redMeteorite = UIImageView(image: UIImage(named: "RedMeteorite"))
    var blueMeteorite = UIImageView(image: UIImage(named: "BlueMeteorite"))
    var blackMeteorite = UIImageView(image: UIImage(named: "BlackMeteorite"))
    var orangeMeteorite = UIImageView(image: UIImage(named: "OrangeMeteorite"))
    var greenMeteorite = UIImageView(image: UIImage(named: "GreenMeteorite"))
    
    var meteorites: [UIImageView] = []
    var randomElement: UIView?
    var randomElementOne: UIView?
    private var timer: Timer? = nil
    private var intersectsTimer: Timer? = nil
    private var pointsTimer: Timer? = nil
    
    enum Constants {
        static var shipWidht: CGFloat = 115
        static var shipHeight: CGFloat = 100
        static var meteoriteWidht: CGFloat = 125
        static var meteoriteHeigth: CGFloat = 125
        static var distanceOfShip: CGFloat = 185
        static let closeButtonHeight: CGFloat = 44
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.points = 0
        setupLevel()
        setupViews()
        setupBlurView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        defaults.points = 0
        setupAnimation()
        setupNamePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - private
private extension GameViewController {
    
    func setupViews() {
        
        view.addSubview(background)
        background.contentMode = .scaleAspectFill
        background.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.frame.width, height: view.frame.height)
        view.sendSubviewToBack(background)
        
        view.addSubview(background2)
        background2.contentMode = .scaleAspectFill
        background2.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero - view.frame.height, width: view.frame.width, height: view.frame.height)
        view.sendSubviewToBack(background2)
        
        shipView.frame = CGRect(x: view.center.x, y: view.bounds.maxY - Constants.distanceOfShip, width: Constants.shipWidht, height: Constants.shipHeight)
        shipImage.contentMode = .scaleAspectFill
        shipImage.frame.size = CGSize(width: shipView.frame.width, height: shipView.frame.height)
        view.addSubview(shipView)
        shipView.addSubview(shipImage)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(moveShip))
        shipView.addGestureRecognizer(recognizer)
        
        meteorites.append(redMeteorite)
        meteorites.append(blueMeteorite)
        meteorites.append(blackMeteorite)
        meteorites.append(orangeMeteorite)
        meteorites.append(greenMeteorite)
        
        for meteorit in meteorites {
            meteorit.addSubviews()
            view.addSubview(meteorit)
        }
        
        namePlayer.backgroundColor = .white
        namePlayer.alpha = 0.65
        namePlayer.font = UIFont(name: "UsuallyfontBold", size: 22)
        namePlayer.textColor = .darkGray
        namePlayer.text = NSLocalizedString("nameless",comment: "")
        
        view.addSubview(namePlayer)
        namePlayer.textAlignment = .left
        closeButton.backgroundColor = .white
        closeButton.alpha = 0.65
        closeButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
        view.addSubview(closeButton)
        
        namePlayer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            namePlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            namePlayer.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor),
            namePlayer.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            namePlayer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: namePlayer.trailingAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 38),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 100)])
        
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        pointsLabel.text = "\(defaults.points)"
        view.bringSubviewToFront(pointsLabel)
        view.bringSubviewToFront(litleMeteoriteImage)
    }
    
    func setupBlurView() {
        view.addSubview(blurView)
        view.bringSubviewToFront(blurView)
        blurView.backgroundColor = .white
        blurView.alpha = 0.65
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}

// MARK: - Animation
extension GameViewController {
    
    func setupAnimation() {
       if isPaused {
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(createMeteorites), userInfo: nil, repeats: true)
           
           intersectsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(findIntersects), userInfo: nil, repeats: true)
       }
        
        UIView.animate(withDuration: 11, delay: 0.0, options: [.repeat, .curveLinear], animations: {
            
            self.background.frame = self.background.frame.offsetBy(dx: 0.0, dy: +1 * self.background.frame.size.height)
            self.background2.frame = self.background2.frame.offsetBy(dx: 0.0, dy: +1 * self.background2.frame.size.height)
        }, completion: nil)
    }
}

// MARK: - Action
extension GameViewController {
    
    @objc func close() {
        
        let alert = UIAlertController(title: NSLocalizedString("save_results?", comment: ""), message: nil , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: save))
        alert.addAction(UIAlertAction(title: NSLocalizedString("back", comment: ""), style: .cancel, handler: back))
        present(alert, animated: true, completion: nil)
        
        func save(action: UIAlertAction) {
            
            if defaults.namePlayer == "" {
                defaults.namePlayer = NSLocalizedString("nameless", comment: "")
            }
            
            let newPlayer = String(format: NSLocalizedString("player_with_the_result", comment: ""), defaults.namePlayer ?? "", defaults.points)
            
            defaults.list.append(newPlayer)
            sortingPlayers(with: &defaults.list)
            
            if defaults.list.count > 10 {
                defaults.list.removeLast()
            }
            
            let nextViewController = storyboard!.instantiateViewController(withIdentifier: "LeadersStoryboard")
            present(nextViewController, animated: false, completion: nil)
           isPaused = false
            timer?.invalidate()
            intersectsTimer?.invalidate()
        }
        
        func back(action: UIAlertAction)  {
            dismiss(animated: false, completion: nil)
            isPaused = false
            timer?.invalidate()
            intersectsTimer?.invalidate()
        }
    }
    
    @objc func createMeteorites() {
        
        randomElement = meteorites.randomElement()
        self.randomElement?.frame.origin.x = CGFloat.random(in: 0..<self.view.bounds.maxX - (self.randomElement?.frame.width ?? 0) - (self.randomElementOne?.frame.width ?? 0))
        
        self.randomElement?.frame.origin.y = self.view.frame.minY - (self.randomElement?.frame.height ?? 0)
        
        randomElementOne = meteorites.randomElement()
             self.randomElementOne?.frame.origin.x = CGFloat.random(in: 0..<self.view.bounds.maxX - (self.randomElement?.frame.width ?? 0) - (self.randomElementOne?.frame.width ?? 0))
                                                                    
             self.randomElementOne?.frame.origin.y = self.view.frame.minY - (self.randomElementOne?.frame.height ?? 0)
        
        if let randomElement = randomElement {
            UIView.animate(withDuration: 7,
                           delay: 0, options: [.curveLinear]) {
                randomElement.frame = randomElement.frame.offsetBy(dx: 0.0, dy: +1 * (self.view.bounds.height + randomElement.frame.size.height))
            } completion: { _ in
                if randomElement.frame.maxY == self.view.frame.maxY + randomElement.frame.size.height {
                    print("Первый элемент")
                    self.defaults.points += 1
                }
            }
        }
        
        if let randomElementOne = randomElementOne {
                UIView.animate(withDuration: 7,
                                     delay: 4, options: [.curveLinear]) {
                    randomElementOne.frame = randomElementOne.frame.offsetBy(dx: 0.0, dy: +1 * (self.view.bounds.height + randomElementOne.frame.size.height))
                    } completion: { _ in
                        if randomElementOne.frame.maxY == self.view.frame.maxY + randomElementOne.frame.size.height {
                            print("Второй элемент")
                            self.defaults.points += 1
                        }
                    }
                }
    }
    
    @objc func findIntersects() {
        self.pointsLabel.text = "\(self.defaults.points)"
        if let randomElement = randomElement, let randomElementOne = randomElementOne {
            if self.shipView.frame.intersects(randomElement.layer.presentation()!.frame) || self.shipView.frame.intersects(randomElementOne.layer.presentation()!.frame) {
                let alert = UIAlertController(title: NSLocalizedString("game_over", comment: ""), message: NSLocalizedString("your_result", comment: "") + "\(self.defaults.points)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("list_of_leaders", comment: ""), style: .default, handler: self.openLeaders))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc func moveShip(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            lastShipViewOriginX = shipView.frame.origin.x
            lastShipViewOriginY = shipView.frame.origin.y
        case .changed:
            let translation = recognizer.translation(in: view)
            let newPosition = CGPoint(
                x: lastShipViewOriginX + translation.x,
                y: lastShipViewOriginY
            )
            if  shipView.frame.width + newPosition.x < view.frame.width,
                shipView.frame.minX + newPosition.x > view.frame.minX
            {
                shipView.frame.origin = newPosition
            } else {
                return
            }
        default:
            return
        }
    }
    
    func openLeaders(action: UIAlertAction) {
        
        if defaults.namePlayer == "" {
            defaults.namePlayer = NSLocalizedString("nameless", comment: "")
        }
        
        let newPlayer = String(format: NSLocalizedString("player_with_the_result", comment: ""), defaults.namePlayer ?? "", defaults.points)
        
        defaults.list.append(newPlayer)
        sortingPlayers(with: &defaults.list)
        print(defaults.list)
        
        if defaults.list.count > 10 {
            defaults.list.removeLast()
        }
        
        let nextViewController = storyboard!.instantiateViewController(withIdentifier: "LeadersStoryboard")
        present(nextViewController, animated: false, completion: nil)
        isPaused = false
        timer?.invalidate()
        intersectsTimer?.invalidate()
    }
}

//MARK: - private
private extension GameViewController {
    
    func setupNamePlayer() {
        if defaults.namePlayer?.isEmpty == false {
            namePlayer.text = "\(defaults.namePlayer!)"
        }
    }
    
    func sortingPlayers(with array: inout [String]) {
      var dictionaries = [String: Int]()
      for players in array {
        if let number = Int(players.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
          dictionaries[players] = number
        }
      }
        array.removeAll()
      array = Array(dictionaries.keys).sorted(by: { (dictionaries[$0] ?? 0) > (dictionaries[$1] ?? 0) })
    }
    
    func setupLevel() {
        switch defaults.level {
        case 0:
            Constants.shipWidht = 100
            Constants.shipHeight = 100
            Constants.meteoriteWidht = 125
            Constants.meteoriteHeigth = 125
            Constants.distanceOfShip = 185
        case 1:
            Constants.shipWidht = 100
            Constants.shipHeight = 125
            Constants.meteoriteWidht = 115
            Constants.meteoriteHeigth = 115
            Constants.distanceOfShip = 245
            background = UIImageView(image: UIImage(named: "BWBackground"))
            background2 = UIImageView(image: UIImage(named: "BWBackground"))
            shipImage = UIImageView(image: UIImage(named: "BWShip"))
            redMeteorite = UIImageView(image: UIImage(named: "BWRedMeteorite"))
            blueMeteorite = UIImageView(image: UIImage(named: "BWBlueMeteorite"))
            blackMeteorite = UIImageView(image: UIImage(named: "BWBlackMeteorite"))
            orangeMeteorite = UIImageView(image: UIImage(named: "BWOrangeMeteorite"))
            greenMeteorite = UIImageView(image: UIImage(named: "BWGreenMeteorite"))
        case 2:
            Constants.shipWidht = 100
            Constants.shipHeight = 160
            Constants.distanceOfShip = 220
            Constants.meteoriteWidht = 115
            Constants.meteoriteHeigth = 115
            background = UIImageView(image: UIImage(named: "OrigamiBackground"))
            background2 = UIImageView(image: UIImage(named: "OrigamiBackground"))
            shipImage = UIImageView(image: UIImage(named: "OrigamiShip"))
            redMeteorite = UIImageView(image: UIImage(named: "OrigamiRedMeteorite"))
            blueMeteorite = UIImageView(image: UIImage(named: "OrigamiBlueMeteorite"))
            blackMeteorite = UIImageView(image: UIImage(named: "OrigamiBlackMeteorite"))
            orangeMeteorite = UIImageView(image: UIImage(named: "OrigamiOrangeMeteorite"))
            greenMeteorite = UIImageView(image: UIImage(named: "OrigamiGreenMeteorite"))
        case 3:
            Constants.shipWidht = 70
            Constants.shipHeight = 160
            Constants.distanceOfShip = 240
            Constants.meteoriteWidht = 100
            Constants.meteoriteHeigth = 100
            background = UIImageView(image: UIImage(named: "CartoonBackground"))
            background2 = UIImageView(image: UIImage(named: "CartoonBackground"))
            shipImage = UIImageView(image: UIImage(named: "CartoonShip"))
            redMeteorite = UIImageView(image: UIImage(named: "CartoonRedMeteorite"))
            blueMeteorite = UIImageView(image: UIImage(named: "CartoonBlueMeteorite"))
            blackMeteorite = UIImageView(image: UIImage(named: "CartoonBlackMeteorite"))
            orangeMeteorite = UIImageView(image: UIImage(named: "CartoonOrangeMeteorite"))
            greenMeteorite = UIImageView(image: UIImage(named: "CartoonGreenMeteorite"))
        default:
            print("Error")
        }
    }
}
