From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: fix the comment format for recently added
 functions
Date: Sun, 4 May 2014 15:21:55 -0400
Message-ID: <20140504192155.GD26279@htj.dyndns.org>
References: <20140424193321.GS29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TDYfBu7iyvVMbuC5unTZIiZrjfMVm4SlHNpSrLOR1Zo=;
        b=tybvOJOlAa17UGNgfzRrKz9HjW9FrTUgNisnYGmDDsdXCFL6YINTSUZhjFKNo74hep
         W/LoGIg8mXqlgo7HafzKwLGXfAUnEAFTCIJbGe4IGvbMi4z9cNPrC+m5I4yAZ5wSrQQY
         gO/w+3vQx9vPbgn4uCc+C8CvETT+6nOjQ57XAJQe3qoyYT80sk62L0ool2NXXJC1UQ/e
         Zi0/YWUNpcszooqM4TPVRyvRuUB36HOYFy1CsuALPD+GiFQRApCWNJy9HIDdecBswHX4
         hU6dgzIbBUYG6aA7Miw2/jZ/iqE7iOcJWGgK8drVXfq6F1DSC02TvcgTxRUwfF+xBAjo
         066g==
Content-Disposition: inline
In-Reply-To: <20140424193321.GS29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Apr 24, 2014 at 03:33:21PM -0400, Aristeu Rozanski wrote:
> Moving more extensive explanations to the end of the comment.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <arozansk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
