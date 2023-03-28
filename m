From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CLONE_INTO_CGROUP probably needs to call controller attach
 handlers
Date: Tue, 28 Mar 2023 17:41:56 +0200
Message-ID: <20230328154156.kcm4nha2jeej74rr@wittgenstein>
References: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680018121;
        bh=bjTXX9yzs6ldEzyQm2t7OD6dEAou4tttEBMCj7d1qu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CaGmLRhSoe2tN/e+4Xm68kM9m9ONdejVT4hYPdtwJZHav25P4Glr1fKvju+8rHoTv
         Ks5VTIw++WHNYpnfjS2KGT3wsn7Pt371wkiy90PmbIxs6rCKUd2H3c/elL02bnMM04
         1lewV3w1Xo3Jz6Ybp3Byh2sBZTzShbe/Ny1G7i6cE5JQtAwtpNwmvbtPOykFU8a5OE
         Gj7RPr4ej+xgNjTg4WuC34Dm+J/SjFesBsV+4mUTUDN1SqPlv4JALXnUNl/eIS2krJ
         VI/KOhHK7DDkgCCpbSeduub2XAMT1m2XqcVlmwyWY39xkBNOb/mUStiuN9rjiWCaO1
         iP0X5N+yIKT5A==
Content-Disposition: inline
In-Reply-To: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, Mar 28, 2023 at 05:39:52PM +0200, Christian Brauner wrote:
> Hey,
> 
> Giuseppe reported that the the affinity mask isn't updated when a
> process is spawned directly into the target cgroup via
> CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
> mask to be updated (see the repro at [1].
> 
> I took a quick look and the issue seems to be that we don't call the
> various attach handlers during CLONE_INTO_CGROUP whereas we do for
> migration. So the solution seems to roughly be that we need to call the
> various attach handlers during CLONE_INTO_CGROUP as well when the
> parent's cgroups is different from the child cgroup. I think we need to
> call all of them, can, cancel and attach.
> 
> The plumbing here might be a bit intricate since the arguments that the
> fork handlers take are different from the attach handlers.

But note, as Johannes already pointed out somewhere else, that there's
probably a lot of code that doesn't apply to the CLONE_INTO_CGROUP case
so it might also make sense to just move the missing pieces into the
fork handlers.
