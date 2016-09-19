From: Vladimir Davydov <vdavydov.dev@gmail.com>
Subject: Re: [PATCH 2/3] cgroup: duplicate cgroup reference when cloning
 sockets
Date: Mon, 19 Sep 2016 18:43:21 +0300
Message-ID: <20160919154321.GG1989@esperanza>
References: <20160914194846.11153-1-hannes@cmpxchg.org>
 <20160914194846.11153-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JBwpTrpipwQ5loVCkFAWPYyRsOec/YPLSH6MWwStG3w=;
        b=bd7pfCGxdLRXJRN7fXx8Ts/3pPCXHttrt8faBA8IRkuWrWhDcIhQYGkK5xryBbU0HX
         zUTwouqvUcEs2qVKfj5yNmZPaRFH+i0CZageLRHv+SFLoZ2dXM3NTSIJ2saZahHu8SeZ
         3CCHHJ+zmAjHTkaslSzQCHpAPoPIUQh5/99A9VLx758h1zZtM9oSt1+k1ul7XZhwCTN8
         ABz+Sh5TQBv4DPbEyTrZSmUO1zxErOJT5OmfvOlKnLnvxR9o70rzv8CmhEKEvu6im4Ez
         hlek824MsxE8ZCxBT90UacdfLqcS45y08I2TgRYDtCYmOQL2OLKIW/TRm3qY7zsbgjhJ
         79+w==
Content-Disposition: inline
In-Reply-To: <20160914194846.11153-2-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Sep 14, 2016 at 03:48:45PM -0400, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@fb.com>
> 
> When a socket is cloned, the associated sock_cgroup_data is duplicated
> but not its reference on the cgroup. As a result, the cgroup reference
> count will underflow when both sockets are destroyed later on.
> 
> Fixes: bd1060a1d671 ("sock, cgroup: add sock->sk_cgroup")
> Cc: <stable@vger.kernel.org> # 4.5+
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vladimir Davydov <vdavydov.dev@gmail.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
