From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH v2 5/5] cgroup: remove struct cgroup_seqfile_state
Date: Thu, 1 Aug 2013 09:11:25 +0800
Message-ID: <51F9B5BD.2070502@huawei.com>
References: <51F8DA99.3010303@huawei.com> <20130731113619.GL2810@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130731113619.GL2810@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On 2013/7/31 19:36, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 05:36:25PM +0800, Li Zefan wrote:
>> We can use struct cfent instead.
>>
>> v2:
>> - remove cgroup_seqfile_release().
>>
>> Signed-off-by: Li Zefan <lizefan@huawei.com>
> 
> Applied to libata/for-3.12.
> 

libata? I hope you didn't. :)
