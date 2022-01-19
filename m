From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] KVM: Move VM's worker kthreads back to the original
 cgroups before exiting.
Date: Wed, 19 Jan 2022 09:05:05 -1000
Message-ID: <Yehg4doAwoUTBHLX@slm.duckdns.org>
References: <20211222225350.1912249-1-vipinsh@google.com>
 <20220105180420.GC6464@blackbody.suse.cz>
 <CAHVum0e84nUcGtdPYQaJDQszKj-QVP5gM+nteBpSTaQ2sWYpmQ@mail.gmail.com>
 <Yeclbe3GNdCMLlHz@slm.duckdns.org>
 <7a0bc562-9f25-392d-5c05-9dbcd350d002@redhat.com>
 <YehY0z2vHYVZk52J@slm.duckdns.org>
 <CAHVum0fqhMQd2uFic5_7RN=Ah6TTH2G2qLNZuxnQXSazR57m6g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <kvm-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rRh+idUwbOdly6bknpYwWmsx3IX/EG0YgmQNjU2Me8w=;
        b=Mn1dOVIkJPRudD5S+4bqqB0SgTsXe1/SRjq9+d/3NLil2nKYd+51WR0mfQqxIdIL7E
         XLuCWZ2RrMpIX3Fa7EPtb1nlgr4P/0Ou8R337jSark5p0P3MQ6uhZ/Io+yVBbaCIvzsL
         DhOJOPXtM51TFNfHTsGDj+j9QN00tHs3tuok0UvznETQqi3kBhSXC0XRQjFYeRWmO/6K
         4eeU7XvljzQPZHNjmj2YBxate/YP9hN4RqJUr723tPynsxtaG7/8j6EdlmYjIhCQuNkr
         hqt1+MXZHZsqBpwMQsX0bZm1+GGPIxZnJwViaI1E4KRSLP7zLsBzptqB3dhZ/nazKlHy
         raPQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAHVum0fqhMQd2uFic5_7RN=Ah6TTH2G2qLNZuxnQXSazR57m6g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, seanjc@google.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, dmatlack@google.com, jiangshanlai@gmail.com, kvm@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jan 19, 2022 at 10:49:57AM -0800, Vipin Sharma wrote:
> Sean suggested that we can use the real_parent of the kthread task
> which will always be kthreadd_task, this will also not require any
> changes in the cgroup API. I like that approach, I will give it a try.
> This will avoid changes in cgroup APIs completely.

Yeah, that's better than the original but still not great in that it's still
a workaround and just pushes up the problem. You can get the same race if
the cgroups are nested. e.g. if you have a kvm instance under a/b and when
kvm exits, the management software removes b and then realizes that a is
empty too and then tries to delete that too.

It'd be great if we can make kthread_stop actually wait for what most others
consider thread exit but if we're just gonna work around them, just doing it
in userspace might be better - e.g. after kvm exits, wait for !populated
event (this is a pollable event) on the cgroup and then clean up.

Thanks.

-- 
tejun
