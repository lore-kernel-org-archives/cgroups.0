From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix obsolete function name above
 css_free_rwork_fn()
Date: Wed, 2 Aug 2023 09:38:16 -1000
Message-ID: <ZMqwqHhOkskbdqBR@slm.duckdns.org>
References: <20230801124034.2245419-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691005098; x=1691609898;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HGZYAlYoxklSxp+0rfvYKT0X2lcn2CrtNxj5gHKMWqA=;
        b=H0zyghXvQ6QELgoTQI+HxL9wqBt7AeShb9cF8ZMiw/lQylkQtm0H/HSEUj4pKWhh2h
         u0kT4xv3H1N4gK1NmInwfVo4wKJ5mWr91qAUSWmOUS5nYV5ecYeu2Om+UXNd9HWz/9bz
         q/N4nzhH9FfFMwm3keoxAHEqbZPBnqJzHx45ov/yuTM/IqL76srJaVFlYhi615OVj+zT
         D4TJC4mO0+Hpsr5sTrdC+4U8wM8bO08kAN97ct9yxJNEbsPYtpWkubXmJd9To4Xui21s
         IlMRw+pRB7Lfflz5zA65mx4reNkNpfgO85rBvLdTHd9tye8Y8RtOfNBAktja8ciuczGH
         23GQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230801124034.2245419-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 01, 2023 at 08:40:34PM +0800, Miaohe Lin wrote:
> Since commit 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu
> and work item"), css_free_work_fn has been renamed to css_free_rwork_fn.
> Update corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
