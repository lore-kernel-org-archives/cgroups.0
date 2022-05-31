From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: wait for css offline when rmdir
Date: Tue, 31 May 2022 07:22:35 -1000
Message-ID: <YpZO26mJ3Wm0AeHo@slm.duckdns.org>
References: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
 <YpCQZ5RRnxwh7fmK@slm.duckdns.org>
 <e74e03f1-cb54-b158-a085-2965fd088d1d@loongson.cn>
 <YpVo4XiIDu68w40Z@slm.duckdns.org>
 <fbb820c5-dbcb-0f00-c365-d3c57ca27edf@loongson.cn>
 <YpZOIz/CbQs+aWF6@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9PHjFs0sIqj5lWkWsEGrk3cMVyvsTEeIL+bMtOtQI8g=;
        b=OBgz4OH07SYHRH6i23pXY3sWr1cgmBDmYWyyjFcfiUuhnPmpDeeb2eN9o2IHsnITBz
         V9SNk8FW9410NeGJYcONzvZjmXcODw60CjZo9oJFy09hjtKcQKrrG55qdu0nXK/t3m0A
         FITf826d/mlqQmC9tVBZzzMU9TgRmiBlzmZp8CdGUftW2jj3C7HSWBQdFOMeaX/kdbd+
         mhK+WUW4hhuHqvysNs+J/lr01kTV5IPSMSEispnTynIofVHsFumoYmX+MUC1CFDAFEVo
         X/gF0pBGpAAYb0CXt7NfL56W/1E890doIHdDr92hZoZKimXBIlUnxDN4C45iYSbLfpcy
         UddA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YpZOIz/CbQs+aWF6-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hongchen Zhang <zhanghongchen-cXZgJK919ebM1kAEIRd3EQ@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 31, 2022 at 07:19:31AM -1000, Tejun Heo wrote:
> Maybe just keep the sequence numbers for started and completed offline
> operations and wait for completed# to reach the started# on memcg alloc
> failure and retry? Note that we can get live locked, so have to remember the
> sequence number to wait for at the beginning. Or, even simpler, maybe it'd
> be enough to just do synchronize_rcu() and then wait for the offline wait
> once and retry.

Also, given that it's an memcg ID issue. It probably makes sense to
implement it on the memcg side.

Thanks.

-- 
tejun
