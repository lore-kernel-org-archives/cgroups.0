From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/11] x86: tboot: avoid
 Wstringop-overread-warning
Date: Tue, 23 Mar 2021 00:13:32 +0100
Message-ID: <20210322231332.GA1984184@gmail.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=tYvb3I5DkX3N6jN+5U7mg9SkFokyTC7DYO1POXsmyXA=;
 b=JAukgRqBFlBqYxoTg07QIe3L0u4Zd4pnU8/KawSiQ9CobCuM3gzIOiljfx6LuzgDWA
 UowTprAJ6pvQSXvs4KSQRoxyhk97bRV/HvA6p2Z7/U2jyU55VRoMchp/WW94qOWwfctx
 xjztqDCBK6KyOMwxPOwi4e26tFik5N8gD8ME46WI4P9N9+IGYjmYXftjUoCOmT9YRUhI
 oxS7NQe6LKxh0Fe3YkrHljuKHXVZGAd59GORjepGb1sCy/oTzRkzKEYxW8PIJ/sFr1d6
 zI5HyhOjX7JC0HU1eEG4mNxiJ04gBc9w35eUnfsZO8LW67/ihxMVwREYJPst2Xb0XGu3
 JGJw==
Content-Disposition: inline
In-Reply-To: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
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
To: Martin Sebor <msebor@gmail.com>
Cc: dri-devel@lists.freedesktop.org, "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>, linux-scsi@vger.kernel.org, x86@kernel.org, James Smart <james.smart@broadcom.com>, tboot-devel@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, intel-gfx@lists.freedesktop.org, Serge Hallyn <serge@hallyn.com>, Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Ning Sun <ning.sun@intel.com>, Anders Larsen <al@alarsen.net>, Borislav Petkov <bp@alien8.de>, cgroups@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@kernel.org>, Martin Sebor <msebor@gcc.gnu.org>, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, ath11k@lists.infradead.org, linux-security-module@vger.kernel.org, Tejun Heo <tj@kernel.org>, Simon


* Martin Sebor <msebor@gmail.com> wrote:

> > I.e. the real workaround might be to turn off the -Wstringop-overread-warning,
> > until GCC-11 gets fixed?
> 
> In GCC 10 -Wstringop-overread is a subset of -Wstringop-overflow.
> GCC 11 breaks it out as a separate warning to make it easier to
> control.  Both warnings have caught some real bugs but they both
> have a nonzero rate of false positives.  Other than bug reports
> we don't have enough data to say what their S/N ratio might be
> but my sense is that it's fairly high in general.
> 
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overread
>   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=wstringop-overflow
> 
> In GCC 11, all access warnings expect objects to be either declared
> or allocated.  Pointers with constant values are taken to point to
> nothing valid (as Arnd mentioned above, this is to detect invalid
> accesses to members of structs at address zero).
> 
> One possible solution to the known address problem is to extend GCC
> attributes address and io that pin an object to a hardwired address
> to all targets (at the moment they're supported on just one or two
> targets).  I'm not sure this can still happen before GCC 11 releases
> sometime in April or May.
> 
> Until then, another workaround is to convert the fixed address to
> a volatile pointer before using it for the access, along the lines
> below.  It should have only a negligible effect on efficiency.

Thank you for the detailed answer!

I think I'll go with Arnd's original patch - which makes the code a 
slightly bit cleaner by separating out the check_tboot_version() check 
into a standalone function.

The only ugly aspect is the global nature of the 'tboot' pointer - but 
that's a self-inflicted wound.

I'd also guess that the S/N ratio somewhat unfairly penalizes this 
warning right now, because the kernel had a decade of growing real 
fixes via other efforts such as static and dynamic instrumentation as 
well.

So the probability of false positive remaining is in fact higher, and 
going forward we should see a better S/N ratio of this warning. Most 
of which will never be seen by upstream maintainers, as the mishaps 
will stay at the individual developer level. :-)

Thanks,

	Ingo
