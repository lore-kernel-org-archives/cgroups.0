From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Thu, 23 Feb 2012 14:38:32 -0800
Message-ID: <20120223223832.GK22536@google.com>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222183351.GD32694@google.com>
 <20120223194109.GI19691@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IcEwbNevvD4f5+5aLUFKKaShwueCXkdyh9aYdsSHI6w=;
        b=voRd/QNOH5OnvNf8C683EtEXaHoDUh8YeLQdE+tV1/cIa7BwDi1LiuVlt+qehoWu5g
         oTnlMxJ6zFYFNLfRQQVFY/mTZwex9Z9I4a/3hI2ZqXfnP9ypoJAg7BH5x4Lo/AF8PHjL
         tYagC29zVRr17GL3ZO1k4uicj6wBiaZ7miOlQ=
Content-Disposition: inline
In-Reply-To: <20120223194109.GI19691-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hello,

On Thu, Feb 23, 2012 at 02:41:10PM -0500, Vivek Goyal wrote:
> Considering everything internally as flat, isn't it simpler. So cgroup 
> tree still might look hierarchical but actually controller treats it
> as.
> 				root
> 		              / / | \ \
> 			    g1 g2 g3 g4 g5

I don't know.  Mixing the above with controllers which implement
proper nesting makes my head explode (why is there a hierarchy at
all?).  Root is always special anyway.  Just treating root differently
and collapsing the rest of hierarchies should do, right?

Thanks.

-- 
tejun
