From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH-block v3 1/2] bdi, blk-cgroup: Fix potential UAF of blkcg
Date: Wed, 14 Dec 2022 09:54:35 -0700
Message-ID: <5fbaea42-14a7-27a8-cea1-3a59161ceba0@kernel.dk>
References: <20221213184446.50181-1-longman@redhat.com>
 <20221213184446.50181-2-longman@redhat.com>
 <Y5jSllwwBdmQ1jQz@slm.duckdns.org>
 <34a8c4a7-a58d-63fc-4599-accf1cbb6aae@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VdMn8MdKqERVq83/l+YeYkH6HVsbE2k4JfbE9pJ1Ypo=;
        b=D+E7a9btXDFAY4h9/TXp95QlTJDLO1Qdr8/uyyoZeUcYY1BfJx680/GCWVnOYNkdrC
         uwS3Ihcc6GS/HH9FobTHT4q6/yO/h+HBfyzj5KqJll1QRfuD/cigJ7qaCfbC/qYDusnQ
         p93GRasXxxai4ma/lZuwCAwp9RWztMdrtx9AesUYzDCJXCmlEp6LHO7VShoahengkD68
         Hf/JvqDQimnkUXDnJN0+2zEWVpAP3EbQTCR7j9G2i942JRgJLzpPlD0zzTUpMUsDn7PK
         JBIA/baZ7ShOWi9jmmY46XJNtwUyQq0zo5jo/71jmEjhytxo9rcE5br8fy/UlWnNStMf
         8xZw==
Content-Language: en-US
In-Reply-To: <34a8c4a7-a58d-63fc-4599-accf1cbb6aae-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "Dennis Zhou (Facebook)" <dennisszhou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yi Zhang <yi.zhang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 12/13/22 12:53=E2=80=AFPM, Waiman Long wrote:
>=20
> On 12/13/22 14:29, Tejun Heo wrote:
>> On Tue, Dec 13, 2022 at 01:44:45PM -0500, Waiman Long wrote:
>>> Commit 59b57717fff8 ("blkcg: delay blkg destruction until after
>>> writeback has finished") delayed call to blkcg_destroy_blkgs() to
>>> cgwb_release_workfn(). However, it is done after a css_put() of blkcg
>>> which may be the final put that causes the blkcg to be freed as RCU
>>> read lock isn't held.
>>>
>>> Another place where blkcg_destroy_blkgs() can be called indirectly via
>>> blkcg_unpin_online() is from the offline_css() function called from
>>> css_killed_work_fn(). Over there, the potentially final css_put() call
>>> is issued after offline_css().
>>>
>>> By adding a css_tryget() into blkcg_destroy_blkgs() and warning its
>>> failure, the following stack trace was produced in a test system on
>>> bootup.
>> This doesn't agree with the code anymore. Otherwise
>>
>> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>=20
> Sorry, I overlooked the commit log in my update. I will update it if I ne=
ed another version, or Jens can make the following edit:
>=20
> css_tryget() -> percpu_ref_is_zero().

Since the other one also needs an edit, would be great if you could
just send out a v4.

--=20
Jens Axboe


