From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Tue, 09 Jul 2013 21:12:55 +0400
Message-ID: <51DC4497.6060107@openvz.org>
References: <20130708100046.14417.12932.stgit@zurg> <20130709153907.GA17972@thunk.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=oFbW8S/X0mTg0ujUM8Y8TY6mN4YMzwAQDG273tv+Tuk=;
        b=bpc9eEJuwGglEXFdtdltSvUjITjB8w66LL0tOJOhRTosBEwnTO7DLZP+9NFlY6qm6F
         G/fRXrD6LzW6UoJHzAtClo/Onwo25Nnki/3auaLAX08tHb5w5ayTLXQyq5pcY2Angxt6
         H4ByvN7cB1mhhouxKzCApaCvBQ0W/o+Q5E3RRWXr7coafJGVDL+4AueX4BVrVe8k2pa/
         XYP38qJntKmY9hNYgluOsEqrRk4UfvL7LuJPxRi2jPExHDuvjY+Eg2ScQtdgEEXG73NI
         EOx9yEqjd/Y86dFDrVp/IWsxd9XWGmrQd4/14XB5fLyeW5/KeLtIuYoOC0NWpLsRZp5Y
         YLQA==
In-Reply-To: <20130709153907.GA17972-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Theodore Ts'o wrote:
> Another major problem with this concept is that it lumps all I/O's
> into a single cgroup.  So I/O's from pseudo filesystems (such as
> reading from /sys/kernel/debug/tracing/trace_pipe), networked file
> systems such as NFS, and I/O to various different block devices all
> get counted in a single per-cgroup limit.
>
> This doesn't seem terribly useful to me.  Network resources and block
> resources are quite different, and counting pseudo file systems and
> ram disks makes no sense at all.

Yep, I know it. I've already mentioned about this as first planned improvement:

|* Split bdi into several tiers and account them separately. For example:
|  hdd/ssd/usb/nfs. In complicated containerized environments that might be
|  different kinds of storages with different limits and billing. This is more
|  usefull that independent per-disk accounting and much easier to implement
|  because all per-tier structures are allocated before disk appearance.

Accounting each BDI separately doesn't very useful too, so I've chosen
something in the middle.

>
> Regards,
>
> 					- Ted
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email:<a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org">  email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org</a>
