From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/rstat: check updated_next only for root
Date: Thu, 6 Jan 2022 00:35:42 +0000
Message-ID: <20220106003542.d247w7qwtq6ajyii@master>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
 <20211225000932.7253-2-richard.weiyang@gmail.com>
 <20220105193504.GD6464@blackbody.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cGAzTbWX9bWY3ictCjgA8akddhtFPaclmkpNp73lsao=;
        b=q7mMbkzjeK1zBEQMn6eLSgiX7Z8jq4kGR6m+fJD9lToHZcbEEjkLla6ISvICWYSxHO
         cTwifW0ABF+IdxL0ETd+ZZnhN+V/ZPVPbIt7H4kAPHpbrPdysuNTellN9I6OTiWCuZkC
         e6VA9zt46eJQETKvBl6bpqNb/T2I6UiYO+ZQALwPfr4UNoujIEObeZ20Fx0f+nQZ7pRj
         gq6qB7cfiN8ERC6gflGtPL8NEIhhiAqweSgnzo8S0hy5yANX52M3pesMr1+bRulnWWBU
         YjejqAibkBxWyWqtr3OumMmyOGWyU2Vlu8WbjezChpIZ0cqRM6f1ZDB5lqGHqkO2z2Bb
         x96A==
Content-Disposition: inline
In-Reply-To: <20220105193504.GD6464-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Koutn? <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jan 05, 2022 at 08:35:04PM +0100, Michal Koutn? wrote:
>On Sat, Dec 25, 2021 at 12:09:32AM +0000, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> This means we can remove the check on ->updated_next, if we make sure
>> the subtree from @root is on list, which could be done by checking
>> updated_next for root.
>
>Nice refactoring.
>
>> @@ -96,9 +97,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
>>  	 * We're gonna walk down to the first leaf and visit/remove it.  We
>>  	 * can pick whatever unvisited node as the starting point.
>>  	 */
>> -	if (!pos)
>> +	if (!pos) {
>>  		pos = root;
>> -	else
>> +		// return NULL if this subtree is not on-list
>> +		if (!cgroup_rstat_cpu(pos, cpu)->updated_next)
>> +			return NULL;
>> +	} else
>+		/* return NULL if this subtree is not on-list */
>
>Just a coding style nitpick.

Thanks for comment. Would you like me to send a v2?

>
>The patch is otherwise
>Reviewed-by: Michal Koutn? <mkoutny-IBi9RG/b67k@public.gmane.org>

-- 
Wei Yang
Help you, Help me
