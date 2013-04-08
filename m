From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 8/8] cgroup: kill css_id
Date: Mon, 8 Apr 2013 08:51:42 -0700
Message-ID: <20130408155142.GF3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627E8E.1010204@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=j9xMNfeSFk+gjoWZhNZP1VMY0jnhn1Gcm4mwoI4nGZU=;
        b=aXW3RbKudRL0VwNhtNIpedTUI4+QD12M+2iTcw5BUp3U9brDXiQ6lBNUdrK0y4ZVHw
         Nl3NUpaxmSrdjBnunzKMogZRM01+5cAyIEWevQ1dzTNVzOGnuPnzuYV2/r50BWHNRsBF
         nkuNsjN42emCBGYRkMpyOaOodzRauLSlCRBr3o/FiB7nuatLTOoDuO3UGBmDmDwxStTm
         6QeSwHNgq+qSFHaq36jsSUPk8/Kbq64iQV7DkYsyZMmSfHcQ30vR18AEm214457qyZDX
         JZx5VFHJL9tf72I/ENJS175n/UNH362ZBArg8BbehwOzJ2BlJCNLfmC6q65EaMISsuxN
         aPQg==
Content-Disposition: inline
In-Reply-To: <51627E8E.1010204@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon, Apr 08, 2013 at 04:23:42PM +0800, Li Zefan wrote:
> The only user of css_id was memcg, and it has been converted to
> use cgroup->id, so kill css_id.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Violently-acked-by: Tejun Heo <tj@kernel.org>

Thanks a lot for killing this abomination.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
