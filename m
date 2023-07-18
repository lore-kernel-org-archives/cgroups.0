From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Tue, 18 Jul 2023 18:41:27 +0300
Message-ID: <CU5EUJDXM616.SQKBEGB2RLHL@suppilovahvero>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
 <CU4OCLEHU1S5.359W394902648@seitikki> <ZLWPN_xyGFrqqJkV@slm.duckdns.org>
 <op.178pr1qewjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <op.178te0tbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689694894;
        bh=2z4VemvJVhwmItrQCFbXp9Jgb8x1GmS7nNXmRAUmxe4=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=b7YN7txj1on5brdZbnALpUA94GYmyReQ+rClZl8Mz2bWYBYwgmIEkm8pdca4djZv/
         M0/ca7LkPW9RLp4P5PxIhT4+N4GIFM0+SDwh848mHn+4gCX/qzKQDzYdF/H9OdGwA2
         LqF+D+CokWv5RrrXVPnDyJ80a2/otiTTB4iz9ik+d0/+wa7T3aHw7GUMCpflWkoxJ5
         8ocmj/cGk3YWBFL0Cbe1589RT4WHM40Sbl5wCDRS9LLcaY1bliMbadfrb/dDmlHV8e
         2s0h4K2G6ILAYhmyVG/Wf6mi64APUa8G9zu3M2+1psXxsFLMceexRWUl36HHyJU2ym
         IVDuIGvKOZKBw==
In-Reply-To: <ZLWmdBfcuPUBtk1K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Mon Jul 17, 2023 at 11:37 PM EEST, Tejun Heo wrote:
> Hello,
>
> On Mon, Jul 17, 2023 at 03:19:38PM -0500, Haitao Huang wrote:
> > Actually, we are using atomic_long_t for 'current' which is the same wi=
dth
> > as long defined by arch/compiler. So new_usage should be long to be
> > consistent?
>
> We can use atomic64_t, right? It's slower on 32bit machines but I think i=
t'd
> be better to guarantee resource counter range than micro-optimizing charg=
e
> operations. None of the current users are hot enough for this to matter a=
nd
> if somebody becomes that hot, the difference between atomic_t and atomic6=
4_t
> isn't gonna matter that much. We'd need to batch allocations per-cpu and =
so
> on.

In our context, the microcode of SGX could support 32-bit but by design
we only support 64-bit. So at least with the current implementation this
would not be an issue for SGX.

BR, Jarkko


