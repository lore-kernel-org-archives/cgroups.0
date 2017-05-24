From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH v2 12/17] cgroup: Remove cgroup v2 no internal
 process constraint
Date: Wed, 24 May 2017 13:05:27 -0400
Message-ID: <20170524170527.GH24798@htj.duckdns.org>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-13-git-send-email-longman@redhat.com>
 <20170519203824.GC15279@wtj.duckdns.org>
 <93a69664-4ba6-9ee8-e4ea-ce76b6682c77@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Q8c0RzRkOdvvk2NLiIHooLWbaHPIF60o6iUpPlhXWZ4=;
        b=nqjE/Q+PNKf1wBavtXEvfQPOAVlQv4pZ61LmNvWmTZrggVZmg220QZ7j0NDKp5sz81
         myJsH4j+E+2qFC69NtjRmPK5PaVLLTGaWn5DEHcZmpDGyHTiSzDvb63AwOzc3f4CSIDf
         Mg3Pz2r7YNLh/MC3YVIv6/Vhd0BIFvZx3lrCFGxJZF3Gy6exvwk8fXFoHgHgA7mNwMm8
         oy8n9En/5y2HGEnOMgV1uV86uwDtRmKYuI/8UBUsDOo82DXD1zbCJC7Z1o1QCIpwcClN
         hMHLRgr4l2Fd/GEOdy29WdOrgaXkasR7BF+jE2xHw7vv918UCs8j+E95FRU9mzeDz3bZ
         FbIw==
Content-Disposition: inline
In-Reply-To: <93a69664-4ba6-9ee8-e4ea-ce76b6682c77@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

Hello,

On Mon, May 22, 2017 at 12:56:08PM -0400, Waiman Long wrote:
> All controllers can use the special sub-directory if userland chooses to
> do so. The problem that I am trying to address in this patch is to allow
> more natural hierarchy that reflect a certain purpose, like the task
> classification done by systemd. Restricting tasks only to leaf nodes
> makes the hierarchy unnatural and probably difficult to manage.

I see but how is this different from userland just creating the leaf
cgroup?  I'm not sure what this actually enables in terms of what can
be achieved with cgroup.  I suppose we can argue that this is more
convenient but I'd like to keep the interface orthogonal as much as
reasonably possible.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
