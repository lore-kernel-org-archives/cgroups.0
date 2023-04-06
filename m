From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] mm: oom: introduce cpuset oom
Date: Thu, 6 Apr 2023 11:53:27 -0400
Message-ID: <36b96b9c-d08a-e97c-05ff-152d671880e6@redhat.com>
References: <20230404115509.14299-1-ligang.bdlg@bytedance.com>
 <ZCw0sR6IqYa5Es7Q@dhcp22.suse.cz>
 <342c1967-8a68-275c-042e-765d5993157c@redhat.com>
 <cc77d706-7baf-951b-13a5-3470c2b1bba9@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680796414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfBJz2JCY2tXUX/6IQuIUiWHj7GX2hI633TNpoPdRVg=;
        b=C3x8Bvz6t59Z3OT3pV0GgaWxB8X/rpHD63tVFjCsHEMWuh3l7krH2ZzNw2bM9jKskDz+Xu
        Ca0NjNtmHiXOZeqo5AeTd2eUa+COMTL1bWLTYmxcKS+/rmKdWbFtGhvVgQImTYiZzhQgu2
        j3mXTSVmOe0ss5K641fR4tIBZiXuUp8=
Content-Language: en-US
In-Reply-To: <cc77d706-7baf-951b-13a5-3470c2b1bba9@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Gang Li <ligang.bdlg@bytedance.com>
Cc: rientjes@google.com, linux-kernel@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org


On 4/6/23 09:02, Gang Li wrote:
> On 2023/4/5 01:24, Waiman Long wrote:
>>
>> You will also need to take cpuset_rwsem to make sure that cpusets are=20
>> stable. BTW, the cpuset_cgroup_scan_tasks() name is kind of=20
>> redundant. I will suggest you just name it as cpuset_scan_tasks().=20
>> Please also add a=20
>
> mem cgroup oom use `mem_cgroup_scan_tasks`.
> How about keep `cpuset_cgroup_scan_tasks` for naming consistency?

The "memory cgroup" term is used to identify the code related to memory=20
cgroup controller. Cpuset, on the other hand, is a well known cgroup=20
controller. Cpuset cgroup is not a term that people will normally use.=C2=
=A0=20
That is why this name is awkward.

Cheers,
Longman

