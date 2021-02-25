From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC 1/2] cgroup: sev: Add misc cgroup controller
Date: Thu, 25 Feb 2021 11:28:46 -0800
Message-ID: <YDf6bpSxX6I5xdqZ@google.com>
References: <20210218195549.1696769-1-vipinsh@google.com>
 <20210218195549.1696769-2-vipinsh@google.com>
 <YDVIdycgk8XL0Zgx@blackbook>
 <YDcuQFMbe5MaatBe@google.com>
 <YDdzcfLxsCeYxLNG@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=eg2T+GAall58PHie1pc/1M6D3b3c5ZA2F5gwbRjHzXI=;
        b=XAH5DbX0NmfVOZxrBQ+uQ636JLbgHKyf211mfe0oio2b5HL4OwBHllfrayb5aPqFAn
         nWNdqykSp2SPQx8Gx5x6frsT1jZ7KF1iNTaqjfzHL6P/RXcS9j0n0kFaXHlVnybSjAmr
         T1sA3Q5mtuCtDlkBw7zl9DfLWWrlAGvpl4t6ID1wDcTcdcLipJRr/R+Yj5j6iqpt21sw
         zKLoW2cRYxfCfjqcqsZD9GL+j3uWv5aUfKAsQ8t9kBvHkV5GMMwUeXIPqFKbR0oElrRx
         m9ja9x2qv+DAe51QHMjWLI/k1N14adZPcUKSnBErPA5m/lSfEBsTmqVhKa5otSB0NDb0
         fhQw==
Content-Disposition: inline
In-Reply-To: <YDdzcfLxsCeYxLNG@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: thomas.lendacky@amd.com, tj@kernel.org, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 25, 2021 at 10:52:49AM +0100, Michal Koutn=FD wrote:
> On Wed, Feb 24, 2021 at 08:57:36PM -0800, Vipin Sharma <vipinsh@google.co=
m> wrote:
> > This function is meant for hot unplug functionality too.
> Then I'm wondering if the current form is sufficient, i.e. the generic
> controller can hardly implement preemption but possibly it should
> prevent any additional charges of the resource. (Or this can be
> implemented the other subsystem and explained in the
> misc_cg_set_capacity() docs.)

My approach here is that it is the responsibility of the caller to:
1. Check the return value and proceed accordingly.
2. Ideally, let all of the usage be 0 before deactivating this resource
   by setting capacity to 0

But I see your point that it makes sense for this call to always
succeed. I think I can simplify this function now to just have xchg() (for
memory barrier) so that new value is immediately reflected in
misc_cg_try_charge() and no new charges will succeed.

Is the above change good?

>=20
> > Just to be on the same page are you talking about adding an events file
> > like in pids?
> Actually, I meant just the kernel log message. As it's the simpler part
> and even pid events have some inconsistencies wrt hierarchical
> reporting.

I see, thanks, I will add some log messages,=20

if (new_usage > res->max || new_usage > misc_res_capacity[type)) {
  pr_info("cgroup: charge rejected by misc controller for %s resource in ",
          misc_res_name[type]);
  pr_cont_cgroup_path(i->css.cgroup);
  pr_cont("\n");
  ...
}

Only difference compared to pids will be that here logs will be printed
for every failure.

I was thinking to add more information in the log like what is the current
limits (max and capacity) and what new usage would have been. Will there
be any objection to extra information?

>=20
> > However, if I take reference at the first charge and remove reference at
> > last uncharge then I can keep the ref count in correct sync.
> I see now how it works. I still find it a bit complex. What about making
> misc_cg an input parameter and making it the callers responsibility to
> keep a reference? (Perhaps with helpers for the most common case.)

Yeah, that can simplify the misc controller, I will have to add couple of
more helper APIs for callers having simple use cases. I will make this
change.

Thanks
Vipin
