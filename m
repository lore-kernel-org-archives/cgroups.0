From: Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH 1/6] memcg: replace unsigned long by u64 to avoid overflow
Date: Sat, 23 Jun 2012 17:03:39 +0800
Message-ID: <20120623090339.GA6184@kernel>
References: <1340432134-5178-1-git-send-email-liwp.linux@gmail.com>
 <20120623081514.GJ27816@cmpxchg.org>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LYgN2he4b6vzluJYjZMNgwsX1z6APs3mY6D8umxPoag=;
        b=mA9/7eCzuS6/N1wBoeaYPWnUNN0sb9q5SXoilreA9tGyl2619uvs4wE2Db7Hgd2HND
         mV71jhb7HXE7ItwZW1eQ4RNmaAvT+rByA7zGdZPPvIcNV4qQf+riBa2DWF4a+z8hcp9E
         J/qITb7M2NfnEgvuuDzFO7LzZsQUwZr43PH00usws1/JFxnNt7aju6b0mqNnS+oPbtOu
         8TahTx9PNItzpkF/ojn0G6AG5C0D1ZMEx8IY+ncaGcB3dQd22EFa9nlGAyWWHETtJ0Gu
         Rt44aqBrP6c0Jz63982S23VspKa08qTQl6FEcUOKUGYvpOsYnSZuvJjbX0Yz59Ot1oKg
         5aRg==
Content-Disposition: inline
In-Reply-To: <20120623081514.GJ27816@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Gavin Shan <shangw@linux.vnet.ibm.com>

On Sat, Jun 23, 2012 at 10:15:14AM +0200, Johannes Weiner wrote:
>On Sat, Jun 23, 2012 at 02:15:34PM +0800, Wanpeng Li wrote:
>> From: Wanpeng Li <liwp@linux.vnet.ibm.com>
>> 
>> Since the return value variable in mem_cgroup_zone_nr_lru_pages and
>> mem_cgroup_node_nr_lru_pages functions are u64, so replace the return
>> value of funtions by u64 to avoid overflow.
>
>I wonder what 16 TB of memory must think running on a 32-bit kernel...
>"What is this, an address space for ants?"

Hi Johannes,

You mean change all u64 in memcg to unsigned long? or something I
miss....

Regards,
Wanpeng Li

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
