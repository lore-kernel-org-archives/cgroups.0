From: Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>
Subject: Re: [PATCHSET] cpuset: decouple cpuset locking from cgroup core, take#2
Date: Wed, 9 Jan 2013 11:32:18 -0800
Message-ID: <CALdu-PCmeXNF7FCVstVBNRzQDgkhBAPnWs0Czt9HOHZ4mT68-A@mail.gmail.com>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
 <50E93554.3070102@huawei.com> <20130107164453.GH3926@htj.dyndns.org> <50EB76DF.5070508@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        bh=0MA4kjNEjIz5jmi7oCHl/vugJwCiEFguQjB18jZHK/w=;
        b=ty40GaFDaTEHAeVbz5YrjuuDMlCLCPT1iIMg78aWnwYoNN8K8Uu8QSM8+3KsgDJkkN
         JM/OrtczJEnq3roeHjGujsDHZcoBA5PDSEQnFSb8pEe8MDOHhOGFT6MRhfIYbbH0zkR1
         mIzmVEGQ3WhFW4yS4zGGG1cD5QCGpv85nV1NbKRQCxYQvlh/peUiX4V7PZ8pIo8MYq6U
         nvKzClnPE28JNoGnlste2mUWe4QpVyuqG5r8/kZYFF4lZ+xsdQFzKM/isQROwRZP9Ro1
         k7lHIAOx/oyhsZQW38/A5vGiWSwle1zK7ZhwQzbt5Vi5Kh2WhrueW1QKbWxj304+kKDQ
         FRsA==
In-Reply-To: <50EB76DF.5070508-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 7, 2013 at 5:31 PM, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>
> I don't think Paul's still maintaining cpusets. Normally it's Andrew
> that picks up cpuset patches. It's fine you route it through cgroup
> tree.

Yes, I'm sorry - I should have handed on cpusets at the time I had to
hand on cgroups. I was only really ever the maintainer for cpusets
because Paul Jackson asked me to take it over when he retired, as I
understood the cgroups-related parts of it. I never really had a good
grasp of how the some of the lower-level parts of it interacted with
the rest of the system (e.g. offlining, CPUs, scheduler domains, etc)
anyway ...

Paul
