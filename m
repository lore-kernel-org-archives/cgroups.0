From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup filter")
Date: Tue, 28 Jan 2014 16:45:24 -0500
Message-ID: <20140128214524.GA16060@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=4b5QmOufEJJyCcItA5lafWSixRBQz97jbPRu9wDyxDg=;
        b=DO/jhWAGRHnnmM2fQeSWlwR5X9RVCuk/FiF41Pup5WXVpDLq+Ng935yI2H9siHKnMU
         E/3H9/4wDhRpMM9lZsdwKkOjTqIOfvbB0U5Beg7Ep3Rc2Pk7IaB/23M48YS7pJZ9Uex7
         bfz8xAhHeW3fq2mDp2vxUhAR84McFUDKZfbX3ZwpVzn5/baHBU2zfkEhyot8cj8QZbT6
         YV+yBH3KY28MACz9UVshpjWK7v3tvItBb9/XU1hopwykwTSh+JFuc8gHQzAF3QtNJvXg
         UhZZMxSR3nRJ/VnTafo97rDf0+cluWJaQJfNxqHWSalD1rfu/87CSW1ZlBEEdr5Yl6z/
         h1gg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wu Fengguang <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Andi, Wu.

Can you guys please revert 4fd466eb46a6 ("HWPOISON: add memory cgroup
filter"), which reaches into cgroup to extract the inode number and
uses that for filtering?  Nobody outside cgroup proper should be
reaching into that.  In fact, the hard association between vfs objects
and cgroup objects are going away in the upcoming devel cycle.  If you
want to tag on memcg for filtering, please introduce a proper memcg
knob.

Thank you.

-- 
tejun
