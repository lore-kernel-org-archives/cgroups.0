From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH v4 2/2] cgroups: add a pids subsystem
Date: Thu, 12 Mar 2015 11:35:53 -0400
Message-ID: <5501B259.60902@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-1-git-send-email-cyphar@cyphar.com>	<1425606357-6337-3-git-send-email-cyphar@cyphar.com>	<20150309033405.GE13283@htj.duckdns.org>	<54FDED43.4050908@gmail.com>	<CAOviyah2KCu9K7D_H2zAf3LYbnj65P39YPmNamfA=-SSNq4hOg@mail.gmail.com>	<54FED651.6040100@gmail.com>	<CAOviyagpCNcAN4hdhsxffdpE+yDmw+NXx+FikTe64GJ1hQeXhQ@mail.gmail.com>	<55005BAC.9060405@gmail.com> <CAOviyahChsruXvjfu6EJCi49o6R38DHj5iLV92HuyJtfn2a81A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=F1LS1fkJrbojfKeGHYjWu3ogdWYGgP/6tPdGI81WlgM=;
        b=OwPB6LULaJQC3Smmyub61Rd8ogw9jmiZd50XU8HY+Ls0kmVml+7sYC6GQQJ7KBaNYW
         UYgSndxwc/oB4rPe8X+TkOGutXggcyd0IMK0nPcBqB8N+Sdq2n3RiOVeZzeJ+Qr2/E6M
         /DfrVrmtaiwXvV4l7WtqyOvBrqUQMwN6oNkX+kVV7oNQUzoPupzbPQ0hEZSTbbstbpPL
         NjXQbRlln8rtFJEnOe00fuMxP/ZFMRnySu0cgHQT4CxrhbmtRcgrJlatu1olEax/bccV
         0d5YKcMx+/lg2Iey2CHvV7oUnzuESETRvM3ytmtKCzv9sQCzDutpWMVrrlw5uYucEAcJ
         Z3ug==
In-Reply-To: <CAOviyahChsruXvjfu6EJCi49o6R38DHj5iLV92HuyJtfn2a81A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Tejun Heo <tj@kernel.org>, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVj?= =?UTF-8?B?a2Vy?= <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 2015-03-11 22:28, Aleksa Sarai wrote:
>> I did not necessarily word this very clearly.  What I meant is that
>> /proc/sys/kernel/pid_max is essentially an external limiting factor that
>> caps the total number of pids that can be under the root cgroup and it's
>> children, not that the cgroup in any way payed attention to it.  It might be
>> useful to be able to just disable the sysctl option and set the value
>> through the root cgroup, solely or consistency, although such usage isn't
>> something I would consider essential in any way.
>
> Maybe this is something that can be reviewed as a separate patchset to this
> one? I'd much prefer that we actually get per-cgroup process limiting merged
> first, then deal with such features separately.
My thought exactly.
