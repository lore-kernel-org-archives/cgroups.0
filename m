From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Wed, 04 Jul 2012 16:24:35 +0800
Message-ID: <4FF3FDC3.9070108@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881525-5835-1-git-send-email-handai.szj@taobao.com> <4FF291BE.7030509@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=Fkhuf8dke25RJXNgfFxGQerdfg3vtGZOBLPlftWvWfw=;
        b=XMSWS2MW/Ezmu6K0pGImFi8MuoXTZhJJp1ypeg9MDxTfQobaYDWTCYiJkxxC2sy9IW
         +H3kf6KYEpDQFGkSaJtVI1ttX0nKBWkslzJzd37PjUG1vz0sJvmldNaNyik+iDHrpADj
         WZ3kCmD1++v81HDnRz7e+tGr7RFSLld1uq7YFLEj6MdVZyRVZGgzxtys0WDhN5ZSP9uW
         IKj2ABu+oCpFATLQdvf/wcHthr0C14cLvyCKJMRbQ6SxSePUW9OwLeERiB/SZdwuHycc
         qpdIyzFgWyyeswn2w1BKOp9j/HHb4zo+ZnFwn8i9gy5ibZeDCyxtQ4FiOUSan750Xq9v
         SxgQ==
In-Reply-To: <4FF291BE.7030509@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, gthelen@google.com, yinghan@google.com, akpm@linux-foundation.org, mhocko@suse.cz, linux-kernel@vger.kernel.org, Sha Zhengju <handai.szj@taobao.com>

On 07/03/2012 02:31 PM, Kamezawa Hiroyuki wrote:
> (2012/06/28 20:05), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj@taobao.com>
>>
>> Similar to dirty page, we add per cgroup writeback pages accounting. The lock
>> rule still is:
>> 	mem_cgroup_begin_update_page_stat()
>> 	modify page WRITEBACK stat
>> 	mem_cgroup_update_page_stat()
>> 	mem_cgroup_end_update_page_stat()
>>
>> There're two writeback interface to modify: test_clear/set_page_writeback.
>>
>> Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
> Seems good to me. BTW, you named macros as MEM_CGROUP_STAT_FILE_XXX
> but I wonder these counters will be used for accounting swap-out's dirty pages..
>
> STAT_DIRTY, STAT_WRITEBACK ? do you have better name ?

Okay, STAT_DIRTY/WRITEBACK seem good, I'll change them in next version.


Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
