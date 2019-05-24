From: shuah <shuah@kernel.org>
Subject: Re: [PATCH v2 1/3] kselftest/cgroup: fix unexpected testing failure
 on test_memcontrol
Date: Fri, 24 May 2019 15:44:04 -0600
Message-ID: <0c6b76b8-e20c-33f0-21da-64a5d5da30a9@kernel.org>
References: <20190520030140.203605-1-alex.shi@linux.alibaba.com>
 <20190520030140.203605-2-alex.shi@linux.alibaba.com>
 <20190524214035.GG374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558734246;
        bh=TiUA1WFEq7Il0rd+tzTv7rHfLDePXM5hZjMGD293VfM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=cJ+pF9asSBVEbeEPeP4pGA0GV5iHC4bFiFHmwoUEDwMg7DFd9qo4/LIbkBQ4tMJEI
         0P7Xi2JdoC42bXYGpT6WKBUWfmkp7AZszIPijW/GZ8fpUAlM95SC/uT8XAKkzXDsjB
         MsQHY6yNf8WuMRRrrmjS3ZtdwpvPrvdw9ldaJSyY=
In-Reply-To: <20190524214035.GG374014@devbig004.ftw2.facebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Alex Shi <alex.shi@linux.alibaba.com>
Cc: cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, Jay Kamat <jgkamat@fb.com>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, shuah <shuah@kernel.org>

On 5/24/19 3:40 PM, Tejun Heo wrote:
> Hello,
> 
> All three patches look good to me.  Please feel free to add my
> acked-by.  Shuah, should I route these through cgroup tree or would
> the kselftest tree be a better fit?
> 
> Thanks.
> 


Tejun, I can take them through kselftest tree.

thanks,
-- Shuah
