From: Aleksa Sarai <asarai@suse.de>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Fri, 22 Jul 2016 18:30:07 +1000
Message-ID: <177bbc17-5c75-1ff8-0b1f-0c5601fa7e6b@suse.de>
References: <20160720230228.GA19588@mtj.duckdns.org>
 <982fcf3a-3685-9bd7-dd95-7bff255c9421@suse.de>
 <20160720231949.GB19588@mtj.duckdns.org>
 <379e5b13-29d4-ca75-1935-0a64f3db8d27@suse.de>
 <20160721145242.GB22680@htj.duckdns.org>
 <1469113456.2331.16.camel@HansenPartnership.com>
 <20160721150740.GF22680@htj.duckdns.org>
 <1469114194.2331.20.camel@HansenPartnership.com>
 <20160721152648.GA23759@htj.duckdns.org>
 <1469115276.2331.23.camel@HansenPartnership.com>
 <20160721155046.GB23759@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160721155046.GB23759@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Aditya Kali <adityakali@google.com>, Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Christian Brauner <cbrauner@suse.de>, dev@opencontainers.org

>> So if I as the cgroup ns owner am moving a task from A to A_subdir, the
>> admin scanning tasks in all of A may miss this task in motion because
>> all the tasks files can't be scanned atomically?
>
> So, the admin just wants to move processes from A and only A to B.  It
> doesn't wanna interfere with processes in the subdirs or on-going ns
> operations, but if the race occurs, both A -> B migration and ns
> subdir operation would succeed and the end result would be something
> neither expects.

Just to be clear, the "ns subdir operation" is a cgroup namespaced 
process moving A -> A_subdir which is racing against some administrative 
process moving everything from A -> B (but not wanting to move A -> 
A_subdir)?

So should there be policy within the kernel to not permit a process 
outside a cgroup namespace to move processes inside the namespace? Or 
would you be concerned about people escaping the administrator's 
attempts to reorganise the hierarchy?

What if we extended rename(2) so that it /does/ allow for reorganisation 
of the hierarchy? So an administrator could use rename to change the 
point at which a cgroupns root is rooted at, but not be able to move the 
actual processes within the cgroup namespace around? The administrator 
could also join the cgroupns (without needing to join the userns) and 
then just move things around that way?

Do any of those suggestions seem reasonable?

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
