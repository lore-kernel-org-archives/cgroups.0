From: David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH 02/11] x86: tboot: avoid
 Wstringop-overread-warning
Date: Wed, 24 Mar 2021 10:39:57 +0000
Message-ID: <7e05de6cbb554b09ac532c073fab7386@AcuMS.aculab.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
 <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
In-Reply-To: <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: David Laight <David.Laight@ACULAB.COM>, 'Martin Sebor' <msebor@gmail.com>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, James Smart <james.smart@broadcom.com>, "tboot-devel@lists.sourceforge.net" <tboot-devel@lists.sourceforge.net>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>, Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ning Sun <ning.sun@intel.com>, Anders Larsen <al@alarsen.net>, Borislav Petkov <bp@alien8.de>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Martin Sebor <msebor@gcc.gnu.org>, netde

From: David Laight
> Sent: 24 March 2021 09:12
> 
> From: Martin Sebor
> > Sent: 22 March 2021 22:08
> ...
> > In GCC 11, all access warnings expect objects to be either declared
> > or allocated.  Pointers with constant values are taken to point to
> > nothing valid (as Arnd mentioned above, this is to detect invalid
> > accesses to members of structs at address zero).
> >
> > One possible solution to the known address problem is to extend GCC
> > attributes address and io that pin an object to a hardwired address
> > to all targets (at the moment they're supported on just one or two
> > targets).  I'm not sure this can still happen before GCC 11 releases
> > sometime in April or May.
> 
> A different solution is to define a normal C external data item
> and then assign a fixed address with an asm statement or in
> the linker script.

Or stop gcc tracking the value by using:
	struct foo *foo = (void *)xxxxx;
	asm ("", "+r" (foo));

If the address is used more than once forcing it into
a register is also likely to generate better code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)
