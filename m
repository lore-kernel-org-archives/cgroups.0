From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 18:35:30 +0800
Message-ID: <1495535730.2564.5.camel@themaw.net>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <1495472039.2757.19.camel@HansenPartnership.com>
         <1495478092.2816.17.camel@redhat.com>
         <1495480860.9050.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
        :content-transfer-encoding:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-sender
        :x-me-sender:x-sasl-enc:x-sasl-enc; s=fm1; bh=H0DVoL0ivws71bf4AA
        Sjp2mNqA2+bKxVro3FKCqDNLI=; b=ETmUp87BezsIKGakeZKtdYjUtEgsRqvP70
        wA2l9c4CCsiv09PNpHPqWiJRYfHcmT6XRGNIM48j5FPsPU5GwpfvUa0JDr2opSIH
        1HmpUC+lX1isWSeblQR16q/hZ4328aGJ/DTsZFse2QjJY+ttUrGhqQAUCc05/s9p
        ksbIEVZ3gMQj82EN2o9c7VZtLnaTPm01QiYPzP4f2Osp2YRFs5bRH/jaimLLYD+k
        OL8geDBOp9QeM6zbMaHNLRkMAiaCSHUauHlB+JEu3oyWlQmqNP5nLRFXc/gLE0jf
        NBFJ2flRpaiDfIb0x76PYcPUaUxnl8o+Oc/nMo7qxa8yN7f9VT5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc:x-sasl-enc; s=
        fm1; bh=H0DVoL0ivws71bf4AASjp2mNqA2+bKxVro3FKCqDNLI=; b=IEpgX5we
        l6RWPkfY4ugS2DU/CFK+G+laPSAzpKHPxjwvRjN2PnhyUpqidaRhkpKMxJ1SgmqB
        XyOX0AQD52BvsRw4wD6Njy4eZaPUnEoO16uAL5/+rKAhxWI+8eV3/a4+CknmydRK
        6uP6WMQ36MHmHiIa9LyhlvSJhh9ZkvCkETGEqa5iiMtBGPwAFLRV7uELMEPC13cX
        opCuWY6PplEtxsqOi3VKhvWz5jOv+Dnro98WSSUNOYM2Tx50WNbQZMO6tVo1l9e7
        m0fuwxbCMIQlHV3brDhI/62JSD3nT7xq8JUrBgJdXIAvBkEOgsQqZ4OuVq3sFhPm
        fSxq8BB0JcUltQ==
In-Reply-To: <1495480860.9050.18.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Mon, 2017-05-22 at 12:21 -0700, James Bottomley wrote:
> 
> > > >  (3) nfsdcltrack.  A way for NFSD to access stable storage for 
> > > > tracking of persistent state.  Again, network-namespace 
> > > > dependent, but also perhaps mount-namespace dependent.
> > 
> > Definitely mount-namespace dependent.
> > 
> > > 
> > > So again, given we can set this up to work today, this sounds like 
> > > more a restriction that will bite us than an enhancement that gives 
> > > us extra features.
> > > 
> > 
> > How do you set this up to work today?
> 
> Well, as above, it spawns into the root, you jump it to where it should
> be and re-execute or simply handle in the host. 
> 
> > AFAIK, if you want to run knfsd in a container today, you're out of 
> > luck for any non-trivial configuration.
> 
> Well "running knfsd in a container" is actually different from having a
> containerised nfs export.  My understanding was that thanks to the work
> of Stas Kinsbursky, the latter has mostly worked since the 3.9 kernel
> for v3 and below.  I assume the current issue is that there's a problem
> with v4?

Oh, ok, I thought that, say, a docker (NFS) volumes-from a container to another
container didn't work for any version of NFS.

Certainly didn't work last time I tried, it was a while ago though.

Ian
