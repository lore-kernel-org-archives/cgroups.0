From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Documentation: Fix 'file_mapped' -> 'mapped_file'
Date: Tue, 30 Jan 2018 09:53:05 -0800
Message-ID: <20180130175305.GF1121507@devbig577.frc2.facebook.com>
References: <20180130164213.20387-1-florian.schmidt@neclab.eu>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LNxDN1x099L6PPXp3YdY5m4HqNjJ/dSDepWe1yYiQ2c=;
        b=sX6qdi29RI083UX8T0Fl3Q8jteJ0q1btSF6xMXfG0Snt93ZXepsMcWKrvdy+OBzrYz
         GIE5hhZtNQiMb29IZ45U8iei8pr2wkD1YTdH92GYp9IZLl6duWi0tAf9XAthC2crDM4y
         SxDJ7LYJGZlaoCKUfJeP+A5hVOlTua3Jf0MVkCF2PeNpe0+DsX7adcYT0l2pvdqORDv6
         3QTsuoosGzZJ06B+55RtWO5QOiM/GV3ixOgRNTAHjxIfo+OyYjbhkTEDd/4o+1LzWWv1
         6lWvnkqFKGG/3/ms01wZ9uAKlKitK8MpjfOf//iVRCuh3uUz9d8mENo4bwQEq5/HyGtT
         oQvg==
Content-Disposition: inline
In-Reply-To: <20180130164213.20387-1-florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Schmidt <florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 30, 2018 at 05:42:13PM +0100, Florian Schmidt wrote:
> There is no entry file_mapped in the memory.stat file. This looks like a
> simple word flip that's gone unnoticed since 2010 (dc10e281f5fc,
> memcg: update documentation).
> 
> Signed-off-by: Florian Schmidt <florian.schmidt-kcmmt4fgdiuHXe+LvDLADg@public.gmane.org>

Applied to cgroup/for-4.16.

Thanks.

-- 
tejun
