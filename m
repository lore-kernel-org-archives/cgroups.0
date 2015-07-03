From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 22/51] writeback: add {CONFIG|BDI_CAP|FS}_CGROUP_WRITEBACK
Date: Fri, 3 Jul 2015 13:14:19 -0400
Message-ID: <20150703171419.GG5273@mtj.duckdns.org>
References: <1432329245-5844-1-git-send-email-tj@kernel.org>
 <1432329245-5844-23-git-send-email-tj@kernel.org>
 <20150630093751.GH7252@quack.suse.cz>
 <20150702011056.GC26440@mtj.duckdns.org>
 <20150703104957.GH23329@quack.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=t0HYFrn+Odauljnzxr2pyF1GwnTb7BNH5hpQrg96m+w=;
        b=oXMGb9a37erVN1tHsb5Ln+aLOZk5AWgjgIp4D5BPCm4UQlkBJOgJVLLL174ZAN0pLD
         vcFOoy2klZGom5DYiRpxZ3Ds8WYPxe9NYrssIRpHurY8xIZ7JcaeOpEmJf0yv86oVEJs
         xskU+02iOxUY21zErhBc2cqu4htQ1o2pDxurKwTLJqgGsq85eG1EvC/HRzF2iXeWHDQc
         c/a+8hHke3I4QADoCwsLRy574ifc9nkfoo/rY5VH9ao5dDp7mVWMmEdIVUY5X/9nP2Ho
         57y9uskfPcttb4xnYGchQYOdDkJ3qsBGSI3Sy928gGJvof34/JCRfQr+2er573gd4sMv
         ySng==
Content-Disposition: inline
In-Reply-To: <20150703104957.GH23329@quack.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com, david@fromorbit.com, gthelen@google.com, khlebnikov@yandex-team.ru

Hello,

On Fri, Jul 03, 2015 at 12:49:57PM +0200, Jan Kara wrote:
> Well, unless there is some specific mapping for the device, we could just
> fall back to attributing everything to the root cgroup. We would still
> account dirty pages in memcg, throttle writers in memcg when there are too
> many dirty pages, issue writeback for inodes in memcg with enough dirty
> pages etc. Just all IO from different memcgs would be equal so no
> separation would be there. But it would still seem better that just
> ignoring the split of dirty pages among memcgs as we do now... Thoughts?

Sure, if you mark a bdi as capable of supporing cgroup writeback
without enforcing any IO isolation, the above would be what's
happening.  I'm not convinced this would be something actually useful
tho.  Sure, it changes the behavior but is still gonna be a crapshoot.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
