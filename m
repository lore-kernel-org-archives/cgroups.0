From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: ps stuck on cmdline reading
Date: Tue, 3 Feb 2015 20:40:36 +0100
Message-ID: <20150203194036.GA2490@dhcp22.suse.cz>
References: <20150121095808.GA18656@gandi.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xF8COFCzhKuaJaI76s3xnBRRIwK4ApEt/H59kG8qqtk=;
        b=mNvUXoD7XCpKM4aFZEy0H83xPvaAnVexLzN4c9WVqW7dHG3oXoaaYPddxRu0qvzJAD
         IX+aXgh363fRvdCO3M1viWGKPn18DrVPVVBFZFfdD8zegrHCD/C8T+Kp4nb3lP5Vf+Mz
         hGOTEDZl6BL3hq5e1V1tyEbbql0AGkrD0CAKWsY47vVwwCrb+xruXhQIJal532bzLNSZ
         Swsts8zWf4bYQxfvWJFEQomq6gGzK/GhI/Ngo1L8wskSKDwtMWegb8ijg4f2mmkHSTPZ
         15WOLnzjDdB51pwNOpyH4KZhQvlL1O5GsKsm+Qxp6nDY3Mqwt/qFrejY0j6vq+D4/Mso
         DZcA==
Content-Disposition: inline
In-Reply-To: <20150121095808.GA18656-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 21-01-15 10:58:08, William Dauchy wrote:
> Hello,
> 
> I am sometines triggering an issue on a v3.14.x (v3.14.18 here) where
> the `ps auxwwf` is stuck.
> The setup is several containers which own several process and with
> memory limit on each cgroup.
> A strace reveals the `ps` command is stuck on a read of a cmdline
> file. The concerned process itself is on a non-interruptible IO state.
> The ps command is executed in the global cgroup.

What does /proc/<ps pid>/stack say?

-- 
Michal Hocko
SUSE Labs
