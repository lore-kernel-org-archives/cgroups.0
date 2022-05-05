From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] cgroup/cpuset: Remove cpus_allowed/mems_allowed setup
 in cpuset_init_smp()
Date: Thu, 5 May 2022 08:58:14 -1000
Message-ID: <YnQeRppX2bPoqOTL@slm.duckdns.org>
References: <20220427145428.1411867-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hl7WfbK9DHwjRygGR7ADeqierefpNYfJm5+DL9udtug=;
        b=OFfZ/N4ZNieS82RLO2lUXkmMIoP9FiYRII/KMVevjj+bVGRYg+mMTBKbb0/JqotQUX
         9gp5wY5MKel5KW8ncLjcRhENadQvO/QeL3ySyVmwDP57xrwu/6juk+NdBLTkHyXG/rvY
         9lR//nyvP1XRepA7+H29tJouOo+ags2gYvRwTIkcrTGGuNHiqu899zZAmOpWaKRXtq8C
         XHDypD2dSJ4KOm5a7M++yHrAQPG1TUhN7jYAG7KeOrEV6iHCZtdjY4WgBBB2aG4sSg6+
         rxrv54wA8R2U+XoTc29ubK0wCy1tLqZoPSLv7No7NsEvodbNt4t0RdQrjAX0/NVMVp7M
         tnWg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220427145428.1411867-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applied to cgroup/for-5.18-fixes.

Thanks.

-- 
tejun
