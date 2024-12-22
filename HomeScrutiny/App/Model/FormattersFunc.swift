import SwiftUI

func formattedDate(_ dt: Date, frmt: String) -> String {
    let frmttr = DateFormatter()
    frmttr.dateFormat = frmt
    return frmttr.string(from: dt)
}
