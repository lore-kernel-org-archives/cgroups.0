From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Tue, 3 May 2016 11:55:11 -0400
Message-ID: <20160503155511.GA7110@mtj.duckdns.org>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-3-git-send-email-asarai@suse.de>
 <20160502160604.GR7822@mtj.duckdns.org>
 <57280456.1090106@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cJ4Nw2Vn2ripYTSbDlHkFZ8I4cnbHMZaIDnbr+1Wrk4=;
        b=lzlYn+d8+jSkLF63HdLA/c39eyMaFM9B4XEUInUfmKOymPLzN/KRokLicgeofEcCmh
         kkreAO9+5qS1O3j/PpV3iggL0HSe7XCeSeabXQWoOv66h304UrlVhkY23bDqxT6o228r
         BRi5AZjDrXgMiZSyrhFstw805F4kjggiEIxRonZSjxXelbSsMsk1FpUbps8uz6YXC5Cj
         EpZUU7Ng3E4Kd/w5YahpBlzTxbhLBMFlbz8/GURSGgviDBl3FNiGBQ+FmIouFzlnOSI7
         87kJzlXA/lotY9533ZQ4+HfaY0HxB/XgjMjLKpyHN+CUkwG4HrGjBHtPbTDz8M5zFKgf
         A/Lg==
Content-Disposition: inline
In-Reply-To: <57280456.1090106-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hello, Aleksa.

On Tue, May 03, 2016 at 11:52:22AM +1000, Aleksa Sarai wrote:
> However, I agree with James that this patchset isn't ideal (it was my first
> rough attempt). I think I'll get to work on properly virtualising
> /sys/fs/cgroup, which will allow for a new cgroup namespace to modify
> subtrees (but without allowing for cgroup escape) -- by pinning what pid
> namespace the cgroup was created under. We can use the same type of
> virtualization that /proc does (except instead of selectively showing the
> dentries, we selectively show different owners of the dentries).
> 
> Would that be acceptable?

I'm still not sold on the idea.  For better or worse, the permission
model is mostly based on vfs and I don't want to deviate too much as
that's likely to become confusing pretty quickly.  If a sub-hierarchy
is to be delegated, that's upto whomever is controlling cgroup
hierarchy in the sub-domain.  We can expand the perm checks to
consider user namespaces but I'd like to avoid going beyond that.

Thanks.

-- 
tejun
