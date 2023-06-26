From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Mon, 26 Jun 2023 10:31:49 -1000
Message-ID: <ZJn1tQDgfmcE7mNG@slm.duckdns.org>
References: <20230626201713.1204982-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687811510; x=1690403510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OTCUF3XNaBvj4PKCzDGtH7uEP3TDMjaq/uRkjjEZ9Kc=;
        b=cuVy06QAcKG7awJdVWfu3saYHOdNHs21sEzuNJv1hP1fJMvoZXxx44+ki4ge02Zws6
         3+H7SLURjdL0eGT0h09pJSxeORiSBwJC3GZQmDtWew8yDFbmp9pmcn7/+DMlBTpX6D15
         Vf2rCPnevhB4/EoCpVRwAh3pbOxfls3TA4wg83yboMFqod0y+weJAf4BQuTKhFeZBYIz
         yUYxqXLQ9sLYGGdYBlZXxxO+b7aRW5xiPbjVx4FOps38qMnvYtzeqF+/RB66SAD+jSsB
         mLT49KB0jhpZeghMFlfDB4kLvTlGiK9P0huREC178+E7wxC9xlR7So/FVYt7A+DNeLAA
         LdDg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230626201713.1204982-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Mon, Jun 26, 2023 at 01:17:12PM -0700, Suren Baghdasaryan wrote:
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 73f5c120def8..a7e404ff31bb 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -273,6 +273,11 @@ struct kernfs_ops {
>  	 */
>  	int (*open)(struct kernfs_open_file *of);
>  	void (*release)(struct kernfs_open_file *of);
> +	/*
> +	 * Free resources tied to the lifecycle of the file, like a
> +	 * waitqueue used for polling.
> +	 */
> +	void (*free)(struct kernfs_open_file *of);

I think this can use a bit more commenting - ie. explain that release may be
called earlier than the actual freeing of the file and how that can lead to
problems. Othre than that, looks fine to me.

Greg, as Suren suggested, I can route both patches through the cgroup tree
if you're okay with it.

Thanks.

-- 
tejun
