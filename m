From: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Clean up cpuset_task_status_allowed
Date: Tue, 29 Nov 2022 10:53:02 +0800
Message-ID: <db6284ba-b936-b38c-662d-3189c14596e7@shopee.com>
References: <20221125075133.12718-1-haifeng.xu@shopee.com>
 <Y4TqvlOmXqY/CBEc@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVdaZGcP4j88Qml5mJfIo0BmHi+s/R7fEtpX29Aegis=;
        b=eOWHOBNDHn0V8MqJlRrEQyiG3etYoyVj6HwWZjScS+ro7oXp5NnHwhu5V0XnAqkFOl
         6coP5VmkxdS1kKd8anif+2CIXOCyWCUw00MMJ/B7ruMCC30ZGevpet4thlWyKu6g7Mmo
         oxCduW3h3rMAWAq4cf/olag3GY2b+yPIMI2YBT05xMmL0/RfvpD0b99A2JEK5SsjTDsA
         q4MgDxRM4yNHBfjWC2SAQEVHEA+qr+wd4kJUk8aa600dSny2BZsIut+ApQTNkGX8gD+g
         KnPhKTw4NnFHV0or2ZKsD9P0kbjJ7CMEEo6YXfNUfZKQF5scF01DdHZt5KqHaUvgR0oI
         XWzw==
In-Reply-To: <Y4TqvlOmXqY/CBEc-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2022/11/29 01:07, Tejun Heo wrote:
> On Fri, Nov 25, 2022 at 07:51:33AM +0000, haifeng.xu wrote:
>> cpuset_task_status_allowed just shows mems_allowed status, so
>> rename it to task_mems_allowed. Moreover, it's only used in
>> proc_pid_status, so move it to fs/proc/array.c. There is no
>> intentional function change.
>>
>> Signed-off-by: haifeng.xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
> 
> mems_allowed being a very much cpuset feature, I don't see how this is an
> improvement. The new code is different and can be another way of doing it,
> sure, but there's no inherent benefit to it. What's the point of the churn?
> 
> Thanks.
> 

Hi, tejun.

In proc_pid_status, task_cpus_allowed is used to show cpus_allowed, similar to that,
task_mems_allowed is more specific to show mems_allowed. Also cpuset_task_status_allowed
is used to dispaly memory status in '/proc/<pid>/status' and isn't used in other files, so
keep it in the fs/proc/array.c.

Thanks,
Haifeng.

