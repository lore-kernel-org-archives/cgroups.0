From: Topi Miettinen <toiwoton@gmail.com>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Mon, 11 Jul 2016 19:47:44 +0000
Message-ID: <683cdbb9-c414-07c7-16d3-41c4138ddf8d@gmail.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
 <20160711170711.GB3337@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=dF/WQ624PGtRMitxxRjx2iN1F95wf5MV0Tz1aq7GX40=;
        b=QhPUEs1z/rpW+ULwHcp+Ag5IXkUPifLntcrpXG++uAXAGP0J+mDTKfHTu4JHSaon8C
         cnAV+BOR86CTKKictqyu3nOSiGIHlXPHE92nhvSSqpLxobcOUU90Kt3q4ms6V0VkC/di
         QS4KPQW2aXBa0IVWlFCruYHEZfLWnz1nKoM21eChGngOHpbe8Y1y9NEqAnMESlG/Xinc
         1GU1YB/If4lNH0K9MArtTme/bHe5hKawJrBBU+Qw9k0vRYJD7hSwA6xKWsO8LkZl4gwE
         f28t8ENC8nY1f2iqfFXozeQ6p8RMlKOtWtuLWtyci4M3b4HsyypeOJr4d7JpO6uUFaws
         5Txg==
In-Reply-To: <20160711170711.GB3337@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pmladek@suse.com, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, "moderated list:AUDIT SUBSYSTEM" <linux-audit@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On 07/11/16 17:09, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jul 11, 2016 at 02:14:31PM +0300, Topi Miettinen wrote:
>> [   28.443674] audit: type=1327 audit(1468234333.144:520): proctitle=6D6B6E6F64002F6465762F7A5F343639006300310032
>> [   28.465888] audit: type=1330 audit(1468234333.144:520): cap_used=0000000008000000
>> [   28.482080] audit: type=1331 audit(1468234333.144:520): cgroups=:/test;
> 
> Please don't put additions of the two different audit types into one
> patch and I don't think the cgroup audit logging makes much sense.
> Without logging all migrations, it doesn't help auditing all that
> much.  Also, printing all cgroup membership like that can be
> problematic for audit it can be arbitrarily long.
> 
> Thanks.
> 

It's really critical to be able to associate a task in the logs to
cgroups which were valid that time. Or can we infer somehow what cgroups
a task was taking part, long time after task exit? Perhaps task cgroup
membership changes and changes in available cgroups should be logged too?

Some kind of cgroup IDs could be logged instead of long paths. Then
these IDs should be reliably resolvable to paths offline somehow.

How usual migrations between cgroups are? Why would a task ever move
from (say) systemd/system.slice/smartd.service to anywhere else?

-Topi

