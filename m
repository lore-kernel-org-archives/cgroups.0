From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Mon, 02 Mar 2015 08:13:23 -0500
Message-ID: <54F461F3.3030903@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com> <20150227170640.GK3964@htj.duckdns.org> <54F0BC51.4050506@gmail.com> <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com> <20150228115926.GA1005@htj.duckdns.org> <CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ@mail.gmail.com> <20150228164353.GR3964@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=xFy/GGWn8EXG7w3/bdShr8cjm2e4relmbwutnLQvT1A=;
        b=Kc/6E1FPlIvbmL+mHEDKjmEBqwfhLpFq2N2sttHUEKIcdpnx47Q+KK/sFcEQb6pUNS
         EspD+tKD9qZNxEeNyfV+x3EkQT2iu2o2YnPPIdaR/qdfqp7kst2DitJEh79lavApYaf8
         XpnVo+NZkbdyfC91ROnqv9JnGhnr0XNar9HOPjhoEHuNQvygJQM2unwjlkZNonqo85pw
         UucrHmlPsoX85D2fsiMv8XevqvQrJJh4YstyZUtQQ5JGc0Qxlm2ke944EKdTcBQWqwiF
         InO69+K8ZwSze6ppyYkA2zZRVh4mO5SLIoqpp1XazGgWUdxau2sKj4LEQOVquZRlYnOz
         7Khw==
In-Reply-To: <20150228164353.GR3964@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Tim Hockin <thockin@hockin.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, lizefan@huawei.com, richard@nod.at, mingo@redhat.com, Aleksa Sarai <cyphar@cyphar.com>, cgroups@vger.kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org

On 2015-02-28 11:43, Tejun Heo wrote:
> Hello, Tim.
>
> On Sat, Feb 28, 2015 at 08:38:07AM -0800, Tim Hockin wrote:
>> I know there is not much concern for legacy-system problems, but it is
>> worth adding this case - there are systems that limit PIDs for other
>> reasons, eg broken infrastructure that assumes PIDs fit in a short int,
>> hypothetically.  Given such a system, PIDs become precious and limiting
>> them per job is important.
>>
>> My main point being that there are less obvious considerations in play than
>> just memory usage.
>
> Sure, there are those cases but it'd be unwise to hinge long term
> decisions on them.  It's hard to even argue 16bit pid in legacy code
> as a significant contributing factor at this point.  At any rate, it
> seems that pid is a global resource which needs to be provisioned for
> reasonable isolation which is a good reason to consider controlling it
> via cgroups.
If 16-bit PID's aren't a concern anymore, then why do we still default 
to treating it like a 16-bit signed int (the default for 
/proc/sys/kernel/pid_max is 32768)?
