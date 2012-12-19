From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V4] memcg, oom: provide more precise dump info while memcg
 oom happening
Date: Wed, 19 Dec 2012 19:58:44 +0800
Message-ID: <CAFj3OHWG9=sXwr3czHS_eB8Udn_x9afxdS9ScyaNTOMB_foj7g@mail.gmail.com>
References: <1355742187-4111-1-git-send-email-handai.szj@taobao.com>
	<20121218172155.GC25208@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=EXYkfY/hV9SMCjKFaQM7NwGCVaQ/udbcT8lk+nKz0O0=;
        b=Z55DRbeCSKzULUwKDNheKriVjljua6N3t/6Ojr1sR82jZ2f7r4NYhPQJxgjhcJzQ9/
         tu9qjK6mjjbhsP1gJwrN6n8zo3l8HWfZfOsW2tmTenBwKdLpX50edBPGAbuu91w22kwn
         r2w5P3q7ElHLlRHPTzgdL6JzM90c1f+HjOZKYHAAxss68OkhCXrcJ1IU8PGTW3wjXjXb
         bnIsSmaSCs8fsZ+zuU3fmySepx7g8ro6sX/D2C5HqF5mFfSsk2QRh/jNiC1AMCo2Ene6
         nwj2tdpNuC3REJ5STWdkgB8KVMXrNQPomiS9uuW9/sVQNDLzpWX/i508bNXDMv8kbwSK
         P81g==
In-Reply-To: <20121218172155.GC25208@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, linux-mm@kvack.org, Sha Zhengju <handai.szj@taobao.com>

On Wed, Dec 19, 2012 at 1:21 AM, Michal Hocko <mhocko@suse.cz> wrote:
> The patch doesn't apply cleanly on top of the current mm tree. The
> resolving is trivial but please make sure you work on top of the latest
> mmotm tree (or -mm git tree since-3.7 branch at the moment).
>

Oh, sorry for the trial, I'll rebase it on -mm since-3.7 branch.

> This also touches mm/oom_kill.c so please add David into the CC list.
>
> More comments below.
>

OK. Next version soon will fix these issues you've mentioned.

Thanks for reviewing!


Regards,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
