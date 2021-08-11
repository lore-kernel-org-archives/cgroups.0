From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/6] cgroup/cpuset: Properly handle partition root tree
Date: Wed, 11 Aug 2021 15:27:20 -0400
Message-ID: <b7897818-8fe6-8dd8-3ff6-6b15401162ba@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-3-longman@redhat.com>
 <YRQSKZB8rQUsfF2K@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628710044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiwffSXoiH4DxwCpTg6qh9csw8fx7R1FkfmT6DZocnc=;
        b=CyRliTBNRNsLfXCLTY0EZhKVS21jvL2Auc5Su/LojcjPOGhDuJb8oK8MspIiOaWKGufPHS
        f395vfpoq1a7DDL7mzKS0xQrRYROn1GXoOvuv8C2jebsJhIIWSxWZKJfFr5hu6hFsGZ//i
        Utgy7nBiX1XbbKhTFeErpfi+s4xw7ZI=
In-Reply-To: <YRQSKZB8rQUsfF2K-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On 8/11/21 2:08 PM, Tejun Heo wrote:
> Hello,
>
> On Tue, Aug 10, 2021 at 11:06:03PM -0400, Waiman Long wrote:
>> For a partition root tree with parent and child partition roots, this
>> patch will now prohibit changing parent partition root back to member
>> as changes to "cpuset.cpus.partition" should not cause those child
>> partition roots to become invalid.
> So, the general rule is that a descendant should never be able to affect or
> restrict what an ancestor can do in terms of configuration. This is because
> descendant cgroups can be delegated and a system manager sitting at a higher
> level in the hierarchy may not have much control over what happens under
> delegated subtrees.
>
> Given that we're promoting the error state as the first class citizen in the
> interface anyway, wouldn't it be better to keep this in line too?

Disabling partition at the parent level does invalidate all the child 
partitions under it. So it must be done with care when we disable a 
partition.

How about we give some indication that a child partition exist when 
reading cpuset.cpus.partition and recommend double-checking it before 
disabling a partition? For example, we keep track of the number of cpus 
delegated to child partitions. Perhaps we can list that information on read.

With that information available, I have no objection to allow disabling 
a parent partition with child partitions under it.

Cheers,
Longman

