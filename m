From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] writeback and cgroup
Date: Fri, 20 Apr 2012 14:33:01 -0700
Message-ID: <20120420213301.GA29134@google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404175124.GA8931@localhost>
 <20120404193355.GD29686@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120406095934.GA10465@localhost>
 <20120417223854.GG19975@google.com>
 <20120419142343.GA12684@localhost>
 <20120419183118.GM10216@redhat.com>
 <20120420124518.GA7133@localhost>
 <20120420192930.GR22419@redhat.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=VUz8x48YmzHzenhhzFDW+ww8fYqca7qbHGwhC6XnjCo=;
        b=tIxZ4gbrx4mdAEJjUjq3KtRDrd7YLSEXX+Gfwhod9fxX5gV1FIUykRJTlXcPRjyGBl
         jaTQPBmiT+c+lKVjrxATgfWfI2hBxaD4PToNtImEprF9Ocm+Qe4jos2ICGntUhwatpKz
         IE4mUwv21jyZXbrfBA32vGX1a6GTamx4Eex3m1B+H2H76Q8Fc/EOvMgk1Ly6XS/wTOFL
         wj3v41JNXBVFQS36WmYlf0c3I9N94zxsHiKgU30/iHDjcFPaSlvEMy7PpFBVMqN7o9Ya
         ZD1vbnYauSsWWwAxSOuyCXWr7LTKAL23kPWRrqVnud0QgqzSv+tw22sDl35B1kihvV9Z
         Cifw==
Content-Disposition: inline
In-Reply-To: <20120420192930.GR22419@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org, sjayaraman@suse.com, andrea@betterlinux.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, lizefan@huawei.com, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, ctalbott@google.com, rni@google.com, lsf@lists.linux-foundation.org

On Fri, Apr 20, 2012 at 03:29:30PM -0400, Vivek Goyal wrote:
> I am personally is not too excited about the case of putting async IO
> in separate groups due to the reason that async IO of one group will
> start impacting latencies of sync IO of another group and in practice
> it might not be desirable. But there are others who have use cases for
> separate async IO queue. So as long as switch is there to change the
> behavior, I am not too worried.

Why not just fix cfq so that it prefers groups w/ sync IOs?

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
