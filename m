From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mountinfo: implement show_path for kernfs and cgroup
Date: Fri, 6 May 2016 13:42:32 -0400
Message-ID: <20160506174232.GC7110@mtj.duckdns.org>
References: <20160505152058.GC13186@mail.hallyn.com>
 <6db5b7e5-3f15-39bd-cc9e-e3c296378e54@gmail.com>
 <20160506173356.GA1228@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hW5g3oI4z9w9LdFsh/k0IBJKWTqkFz6JR8Zj1s0vDGY=;
        b=ZkAmDmcY1QeMLpuF54X9hKe59OoiCeNE5PZ90PYLGiUfzEplOiiwZnZlbCUhFzuqNH
         +bQaIn8b+vWtYKmrpC382m+bXGEaYAclvbMBeVoHKiI6NPU/IukVvOYJ5DWb9zwpZjWw
         I4wG/7768YfaU9PMIkIEukvcnNTiI32Z94t4r4JZZ0RsTdUvtqfVQ21DnhWJw1dZEAtb
         rmg1BDTsKt+kw3+sGPCZW6LiD9IEL+Xycf3r6dVeEoOYnzC8QSxBuYi68pfLNlJAJ0Z8
         Mf6hQpiIp1ITYOcxLio5mJkwWUW7k1jLtltCzeQPgniIgY4a2OfNtRvIJ0+3U2xYpn6H
         z4Nw==
Content-Disposition: inline
In-Reply-To: <20160506173356.GA1228-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

Hello,

On Fri, May 06, 2016 at 12:33:56PM -0500, Serge E. Hallyn wrote:
> Right.  So in particular, docker wants to do something like:
> 
> bindpath=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $4 }'`
> mountpoint=`grep freezer /proc/self/mountinfo | tail -n 1 | awk '{ print $5 }'`
> mycg=`awk -F: '/freezer/ { print $3 }' /proc/self/cgroup`
> cat ${mountpoint}/${bindpath}/${mycg}/cgroup.procs
> 
> and see its own task.

Can you please make the example more concrete?  e.g. Use actual paths
and show what they show now vs. what they should.

Thanks.

-- 
tejun
