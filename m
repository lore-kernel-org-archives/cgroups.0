From: syzbot <syzbot+b591856e0f0139f83023@syzkaller.appspotmail.com>
Subject: Re: [syzbot] [mm?] kernel BUG in vma_replace_policy
Date: Fri, 08 Sep 2023 11:04:30 -0700
Message-ID: <000000000000e127ec0604dcce27@google.com>
References: <000000000000f392a60604a65085@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-riscv-bounces+glpr-linux-riscv=m.gmane-mx.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=lists.infradead.org; s=bombadil.20210309; h=Sender:
	Content-Transfer-Encoding:Content-Type:List-Subscribe:List-Help:List-Post:
	List-Archive:List-Unsubscribe:List-Id:To:From:Subject:Message-ID:In-Reply-To:
	Date:MIME-Version:Reply-To:Cc:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
	List-Owner; bh=Kp8tAmg80E2vuMNOc7zjwFE9R+yutezHVdaPMdDCi1Y=; b=x6AsxZeQ2jcAM6
	Vsbw6/OCBMGdCjaDmHXMPhoTfKGTNyODtUi0x8XY+FkCdw6PqAK8qJeab49RtB/WZrGABDK/Z8/MK
	k0QTJPFlCgvBXdtfyqDzWpBZoTN9iKUPA3XKLSglZVzWY30nIZfB22fJ+DbDnVFNRHgDMTTiZZg9u
	U8BfB/D0KKFwJDw8flTSYh8L/5RxbPXuK4g2PnnhIpwe0m6PPFBfcNF4s8aIZFCo8XQpfTJtTs1iS
	7rwSh9qg1wToQGkPOIzmUY0P75SRo2Ttlvbw3EQ/IG2TWS/EpZM8dfz5oo3DUJ4hFga28tghL/uUw
	AgmJKwRPNM1bGsjsz1Nw==;
In-Reply-To: <000000000000f392a60604a65085@google.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-riscv/>
List-Post: <mailto:linux-riscv@lists.infradead.org>
List-Help: <mailto:linux-riscv-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-riscv>,
 <mailto:linux-riscv-request@lists.infradead.org?subject=subscribe>
Sender: "linux-riscv" <linux-riscv-bounces@lists.infradead.org>
Errors-To: linux-riscv-bounces+glpr-linux-riscv=m.gmane-mx.org@lists.infradead.org
To: 42.hyeyoo@gmail.com, Liam.Howlett@Oracle.com, agordeev@linux.ibm.com, akpm@linux-foundation.org, alexghiti@rivosinc.com, aou@eecs.berkeley.edu, borntraeger@linux.ibm.com, cgroups@vger.kernel.org, christophe.leroy@csgroup.eu, damon@lists.linux.dev, david@redhat.com, eadavis@sina.com, frankja@linux.ibm.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, hannes@cmpxchg.org, hca@linux.ibm.com, imbrenda@linux.ibm.com, jeeheng.sia@starfivetech.com, jglisse@redhat.com, kvm@vger.kernel.org, leyfoon.tan@starfivetech.com, linmiaohe@huawei.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, mason.huo@starfivetech.com, mhocko@kernel.org, mpe@ellerman.id.au, muchun.song@linux.dev, naoya.horiguchi@nec.com, npiggin@gmail.com, palmer@dabbelt.com

syzbot has bisected this issue to:

commit 49b0638502da097c15d46cd4e871dbaa022caf7c
Author: Suren Baghdasaryan <surenb@google.com>
Date:   Fri Aug 4 15:27:19 2023 +0000

    mm: enable page walking API to lock vmas during the walk

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fd2348680000
start commit:   7733171926cc Merge tag 'mailbox-v6.6' of git://git.linaro...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13fd2348680000
console output: https://syzkaller.appspot.com/x/log.txt?x=15fd2348680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b273cdfbc13e9a4b
dashboard link: https://syzkaller.appspot.com/bug?extid=b591856e0f0139f83023
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d4ecd0680000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1055c284680000

Reported-by: syzbot+b591856e0f0139f83023@syzkaller.appspotmail.com
Fixes: 49b0638502da ("mm: enable page walking API to lock vmas during the walk")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
