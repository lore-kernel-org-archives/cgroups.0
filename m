From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] [RFC] cgroup: reject cgroup names with non-printing
 characters
Date: Sun, 17 Aug 2014 09:41:59 -0400
Message-ID: <20140817134159.GE7679@mtj.dyndns.org>
References: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=3idoCu9jhFhY/wH1rF0FwQAmWp6kIlQ8ATS6XmZacQE=;
        b=gvszaq2WRrbWDkkZ0NaTNTFaPLJiFVP81xoStmPrVgs7Re4AJMKwtNYy5DszoiMs7w
         dcPQL66mno79wn+knzcC7qSZ8fgctsWyRSY9IoqXkznB+Gl6Hb/BjBFiaAwlMYGX5J0f
         gzBGPKJ5TDVjLaF7e3oqJ0ZoQwU5cHqEJvxq6VmWoa3F9lQI3zaMRdqU1np46+hlg/NK
         OuiArEu82mfl7QdjeMQ9pv0wMGzKHel6tRmQVwLoo4M2jWrFpeqhLdcmiJ/J8Vzn4q41
         hhXgPBjYY+rUnf40TrkMkGu9J7JI0A/Zc+3kxM1Xjq+W86A8OXrmPC+xEAnIo8HR9nmK
         Lg3g==
Content-Disposition: inline
In-Reply-To: <1405955516-22016-1-git-send-email-alban.crequy@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alban Crequy <alban.crequy@collabora.co.uk>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>

Hello, Alban.

Sorry about the delay.

On Mon, Jul 21, 2014 at 04:11:56PM +0100, Alban Crequy wrote:
> @@ -4387,6 +4401,11 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
>  	struct kernfs_node *kn;
>  	int ssid, ret;
>  
> +	/* do not create cgroups with bad names */
> +	ret = cgroup_is_used_badchars(name);
> +	if (ret)
> +		return ret;

Let's just reject '\n'.  That should give us a way to parse the path
correctly and I don't want to put more-than-necessary interpretation
on the path string.

Thanks.

-- 
tejun
