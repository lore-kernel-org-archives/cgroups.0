From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Skip subtree root in
 cgroup_update_dfl_csses()
Date: Thu, 28 Jul 2022 07:27:25 -1000
Message-ID: <YuLG/RzJASE/8uTV@slm.duckdns.org>
References: <20220728005815.1715522-1-longman@redhat.com>
 <20220728005815.1715522-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=VbEpbcnRCKhYT7BZ0HSKVgFvbMAakayClnOZvBHVLDM=;
        b=i00rVjg3DaYMhQYt2uaTPpDZXUdlQ+KaCLpjoz3IEIhO1KJkqSkwWpy1/U7Uf/F/aD
         nmFgTkH1TiexdN5J0xFNoxsNwasPcbARyEDdluyAxzkqtOoUZni9gh2nJsVmmZVUf4Xt
         cV/aq3fSAIIAqz8k9rp+jo+k1XdHNaYlqrx0nfsdz0stk4DaDTrhBl4iyUw7qpidmOac
         GGvOSFwVaZrE6LDxLSV1yebcuuUAeZ3zPpMZWUBNFispkFDqlVx2Rk5aLw7LNWPr+Tw7
         ldPZYan//l8svd7n01XrDz4bRjQrKC3gazwQ+N+G9xjNJxI+R0+fooIua330gEkmXpku
         6JWA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220728005815.1715522-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 27, 2022 at 08:58:15PM -0400, Waiman Long wrote:
> The cgroup_update_dfl_csses() function updates css associations when a
> cgroup's subtree_control file is modified. Any changes made to a cgroup's
> subtree_control file, however, will only affect its descendants but not
> the cgroup itself. So there is no point in migrating csses associated
> with that cgroup. We can skip them instead.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.20.

Thanks.

-- 
tejun
