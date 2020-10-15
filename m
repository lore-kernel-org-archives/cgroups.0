From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [ANNOUNCEMENT] resctl-demo (Resource Control Demo)
Date: Thu, 15 Oct 2020 13:12:16 -0400
Message-ID: <20201015171216.GG3845@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=cKc+bNP++EX8fyeI3aXeiHgsKpFOPQVrFxV0jhUJ6Fg=;
        b=p0r50dhkcILtmkik8X5doT3aHa4RN3urlDvhCui/LT+YbnQ1OWZozAHZWskt8bEhIW
         yb6JDEMgozrWHdCgXSyYnq8GD+EOW2TGevh3dhnysvwgt6xNa3Zr2iwgHOLfRKMa+/vU
         5QYR9gwKkCKLuhze9yReIip3bePpABLN3vN9Q1eqosiyKI5XQlQlnfeGwW6N3eq6pBha
         SHgCIvsMq4ZJ9XSz0d8BUSSxihLk9cu9V4hWvL2j5L4aL6HauyHuhU9XTGg8mFQmSise
         AFmWX4NcezYAg/A89RzOfNljjxEqHkmFl/ZcYUDopFWTEekqM6RsyCpKnnTEaD1vQM2m
         1GXw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

resctl-demo which documents resource control features and strategies with
live scenarios has just been released. This documents most stuff that we
learned at FB working with and deploying cgroup2, PSI and oomd.

Setting up the whole environment is still a bit difficult because it depends
on pending kernel patches in devel branches and non-trivial system level
configurations such as btrfs root filesystem, so we've built a system image
which can either be launched in AWS or installed on local machine.
Everything in the image is either already upstream or pending, it's just an
easy way to set things up. Follow the link in the Getting Started section in
README if you wanna check them out.

  https://github.com/facebookexperimental/resctl-demo

Longer term, I'm planning to build benchmark / autotest framework on top so
that we can actually verify and score various aspects of resource control in
terms of both isolation and work conservation.

Thanks.

-- 
tejun
