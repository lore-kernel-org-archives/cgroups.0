From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/5] cgroup: introduce cgroup.kill
Date: Mon, 10 May 2021 10:42:17 -0400
Message-ID: <YJlGSZlZYaaujm2O@slm.duckdns.org>
References: <20210508121542.1269256-1-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=InhY7G+ybOozbNoTmfhu8yZlE9kzFAP76imGYr8FuFs=;
        b=jjdppZ0kKSgG+x06elMGfD3fyyCV6FSKvtXjK+rgq8/wbwL4h4NX9wsmFGIEFMT0FK
         4SBvK6JS07NIZcXf58zIP9G3mIDKuUL6NxklgUgvycAMT3NKmmmLtjwqjiQZ4gIVAVZj
         vRAHQQo64j6ewLFvXMtcUYVknfiwxo6kaCrJddfxmjt/NCOWNic6hPmIys+qGz0G1KV8
         fofE57P7aSNqU1vWEHIkXeueS7hxUUaZ+ifMsX9Xk3ccJ/3eC5HLk0+CCWdakczYTj6r
         S1HW/xoWxNABQ7AtNSceHhXR9YeCHpOlXO7QY6PfdNT0jyAEti3V3GgZwOPUp2JQaZek
         UesQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210508121542.1269256-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.14.

Thanks.

-- 
tejun
