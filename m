From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Fri, 10 Sep 2021 06:32:41 -1000
Message-ID: <YTuIqecqjPKEZcrn@slm.duckdns.org>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <20210909143702.GA13761@blackbody.suse.cz>
 <CAHVum0eGN=v1kLqHQg7HBESp8Kg4aGZFNd4XTpxfeyToXPmPVg@mail.gmail.com>
 <8259b666-f3a4-6788-880c-38d679414bcb@gmail.com>
 <20210910103306.GA24156@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=tgXe1DESruN+/rTizBx5p8iE+/E14BLor/fcAtYbb1Y=;
        b=JuMs70r+VpXKmfURn7r1xAkHa84J7MIyXxrJkKqeGRSLmcEHeI6eBYHRj/UlwtCdzT
         tLuzHwmJ9HIREMcgiVTeB0/5kfb+2ErkdRQLAp5Abzt2CIgawsp6KCa+/x/nJgz2sKxE
         S70frEvrS6JAwVg0zTv9BzJDl/0YytEaj82TLB5AbjAB6cilXZ3nhzAnzwJwMHyzL6DT
         XdmrQ9PcZ8mbVvUigWepdGNjzfdEAr29KT03oozkZhUIfJOCtZI5DODbwWmtTpjcD//X
         OKv9R0gJdnYpeSAFMA6JK4X3AyZRf/3SHjAj883RH1wneUsLki+feIcHSowtHFWucbeb
         tOzg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210910103306.GA24156-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 10, 2021 at 12:33:06PM +0200, Michal Koutný wrote:
> On Fri, Sep 10, 2021 at 01:20:37PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Yeah, this is more reasonable. But there is still one question, whether we
> > need to be consistent with other cgroup subsystems, events and events.local
> > under v1 should not support hierarchy？
> 
> My take is that it's acceptable to present the v2-like files in v1 too
> for the sake of simplicity since:
> - this is not used yet,
> - the v1 is less conventional and
> - the presence of events.local would cater even to cases with tasks in
>   inner nodes.
> 
> It'd be good to have Tejun's insight on this too.

My general appraoch is

* If it's trivial both in terms of complexity and effort to add support for
  cgroup1, oh well, why not?

* Otherwise, don't bother.

* cgroup1 interface is wildly inconsistent anyway, so I wouldn't worry much
  about that.

Thanks.

-- 
tejun
