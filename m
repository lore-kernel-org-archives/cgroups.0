From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/51] memcg: implement mem_cgroup_css_from_page()
Date: Sun, 24 May 2015 17:24:40 -0400
Message-ID: <20150524212440.GD7099@htj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-12-git-send-email-tj@kernel.org>
 <20150522232831.GB6485@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=TjyLHjaAfRWW8BpzjmO4RXdtsD5opO3j1k6kXUGFOv4=;
        b=Jt8nYhFnMpO4sK4S2D9zVcvb58Ptja6YSRPtw2NzVzd10qUyIStixjxHJAEVxSeNqV
         jgcs3gI3UmyrdcJjcTExFwMxDf2yzgSqyiWyLojegov4u3K9338nnNpyx1lPGRG8S9pl
         a26vBPTXSjTFddd5T367VCM5MUUdRat2+Zs49kySWzyY9oHHQf+iFW0q9Mvc4nSPyY8I
         v/vxWBd/wxwFxk9WuDpMnY94nCPO4l97/F1YtitJksYLo+291FzjBFqQ4yvYsOWexqA6
         Qu+EUoXsEXWcOZ4qLirSMw1T4aeV16WjagthL/v81whH9+sAV46qrlYeR9aRdL/zWXjD
         JwPw==
Content-Disposition: inline
In-Reply-To: <20150522232831.GB6485@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Fri, May 22, 2015 at 07:28:31PM -0400, Johannes Weiner wrote:
> replace_page_cache() can clear page->mem_cgroup even when the page
> still has references, so unfortunately you must hold the page lock
> when calling this function.
> 
> I haven't checked how you use this - chances are you always have the
> page locked anyways - but it probably needs a comment.

Hmmm... as replace_page_cache_page() is used only by fuse and fuse's
bdi doesn't go through the usual writeback accounting which is
necessary for cgroup writeback support anyway, so I don't think this
presents an actual problem.  I'll add a warning in
replace_page_cache_page() which triggers when it's used on a bdi which
has cgroup writeback enabled and add comments explaining what's going
on.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
