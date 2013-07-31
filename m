From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 8/8] cgroup: kill css_id
Date: Wed, 31 Jul 2013 07:49:02 -0400
Message-ID: <20130731114902.GP2810@htj.dyndns.org>
References: <51F86D69.2030907@huawei.com>
 <51F86DFC.9060301@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=2iEd+wFmuzTMzuiFi6t4OPX4XKp11z3o8v2gO92XmWc=;
        b=yNVKb9ZszL3B43vuigDp2mgm2GOZ+2ys/LiyHmnpcL7q8KQuaR8WqIHI9BgOF0AVq6
         YX+MCpqpAJiaQiKfQvN542xIStNbgj5gewrAHJihAIO3GIJBY4vqdvQj0uBmtuAlAVsD
         xDNjzsxVAofO4PLnPi/O8fx3JGuycupIhxrvBoKekWPw0tALVvoI6RhYsO9SO8NLjF4r
         ZE5Gp6wSME7ofhLNbDj0SP+CPnspUBuh6DUM7IoDciuk1vaAqeu/t5XZBmzsGAizEHd7
         J5Qqq17EP72jfAvip51bgMqb3vTD3/Jasf3CUgWRhzbkfxdOCjzQDqfzjVFfBeBkflMw
         UQjA==
Content-Disposition: inline
In-Reply-To: <51F86DFC.9060301@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Wed, Jul 31, 2013 at 09:53:00AM +0800, Li Zefan wrote:
> The only user of css_id was memcg, and it has been convered to use
> cgroup->id, so kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huwei.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Violently-acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
