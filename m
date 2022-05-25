From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] cgroup changes for v5.19-rc1
Date: Wed, 25 May 2022 09:44:50 -1000
Message-ID: <Yo6HMpEodz36o4Dc@slm.duckdns.org>
References: <Yowcc/ZOBIIs2JtZ@slm.duckdns.org>
 <CAHk-=wiGsJgFTJ=yqYwWA2vcTWQy=2QQ6to6vd3ETutaE0cDxQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o70OUxKcTNYmgvPxndUPt88zZAQec5YsFXPWqk13pTk=;
        b=iQvt/SGuRVaZDmWBaBqGVRPz/Lr8OjhiODk2rCwVPKbsc4G0Fmry+yHyIpiUTxkxxZ
         bIsMnTXnwCQYmql/ykkMnZtXTr0qB9V838grdlfCMbYJ/W39snefOzCt0rjcwrGk52Yh
         lIiGnUE9ZdJ/YuoNk+OkLkdmah6JlT/Lk1DFbxrDmkHjXeCF9vnXdkZs/2BK4qBblk/Y
         UpqjteOfRRsUI8HrT/Pzd19YJWsjMfYCLbPh6HJ0wuMHo+hl1iyW0zAMFTmUZLm6tgdO
         pMSRg1V2mcfp0Rh1/CJz40fCxDp/XDR8JgWvFNpskDPJtVcoU8RBAifuinFKW3qPu+Yw
         CzoQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHk-=wiGsJgFTJ=yqYwWA2vcTWQy=2QQ6to6vd3ETutaE0cDxQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 25, 2022 at 12:43:09PM -0700, Linus Torvalds wrote:
> On Mon, May 23, 2022 at 4:44 PM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.19
> 
> Your two pulls sadly broke the perfect signed tag streak that we had
> this merge window up until just now.
> 
> I'm very happy to see how people have started doing signed tags for
> everything, but that only makes your pull requests stand out even
> more.
> 
> So yeah, despite not requiring it for kernel.org pulls, I'd _really_
> like to make using signed tags just be the standard behavior for all
> the kernel pull requests.
> 
> Can we try to aim for that next time? Please?

Hahaha, yeah, I lost my private key many years ago, so gotta get that sorted
out first. Will do the signed pull from now on.

Thanks.

-- 
tejun
