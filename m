From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v4 06/11] mm: thp: make split queue lock safe when LRU
 pages are reparented
Date: Tue, 24 May 2022 19:54:35 -0700
Message-ID: <Yo2aa661fepAOvjO@carbon>
References: <20220524060551.80037-1-songmuchun@bytedance.com>
 <20220524060551.80037-7-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653447280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9r78ys+sFIRi18dVakR08V039gBRNdiX9MSBliDjxpI=;
        b=afEYlSyLJ5Xk3VJuKx26Zo0GENFgJqk9oCu0Vx/BwtysJQwObgrzcEzJPc1bjErkGbw2Lx
        r25L7BolKeJgGeXKhsltj9GcWp6BbtTtdWO5E5xHY76UFxwOd1cPXYy4Z3iDfPluyZK9id
        DWWBqP0J9yOpySzBbvxKZmLx2Syr5XE=
Content-Disposition: inline
In-Reply-To: <20220524060551.80037-7-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, May 24, 2022 at 02:05:46PM +0800, Muchun Song wrote:
> Similar to the lruvec lock, we use the same approach to make the split
> queue lock safe when LRU pages are reparented.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Please, merge this into the previous patch (like Johannes asked
for the lruvec counterpart).

And add:
Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> .

Thanks!
