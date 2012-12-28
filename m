From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH V3 5/8] memcg: add per cgroup writeback pages accounting
Date: Fri, 28 Dec 2012 09:52:23 +0900
Message-ID: <50DCED47.6030103@jp.fujitsu.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com> <1356456409-14701-1-git-send-email-handai.szj@taobao.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1356456409-14701-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sha Zhengju <handai.szj@gmail.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, akpm@linux-foundation.org, gthelen@google.com, fengguang.wu@intel.com, glommer@parallels.com, Sha Zhengju <handai.szj@taobao.com>

(2012/12/26 2:26), Sha Zhengju wrote:
> From: Sha Zhengju <handai.szj@taobao.com>
> 
> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
> rule still is:
>          mem_cgroup_begin_update_page_stat()
>          modify page WRITEBACK stat
>          mem_cgroup_update_page_stat()
>          mem_cgroup_end_update_page_stat()
> 
> There're two writeback interface to modify: test_clear/set_page_writeback.
> 
> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
