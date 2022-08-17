From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v2 00/10] sched/psi: some optimization and extension
Date: Wed, 17 Aug 2022 23:19:18 +0800
Message-ID: <42c6d11d-d68a-e869-375e-550c495be5bb@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220815132514.GB22640@blackbody.suse.cz>
 <08ec9c4f-80b2-f731-aa8b-fb4e852ece25@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=2Dzsz0z2prfhgcbdQayKeKRlLfrKQM5D6pSVBtZ7THM=;
        b=GCmgVkz+4yjg/OIcr2ND13CCDmdSh+WHCUT6HE9iMQmhjE4cFo3stnG1YrZoN7u2jA
         X50ubaDBe2N1zPHvWHi9l/NTCLsojyti+EbEBmECP0yxN9mvcFwnCZX6U5UqWeZGV4vd
         UCp9Jj4DkuFnJ2uB+xOIyniJjwYfbdnuS0eTVMFLTlWm6kt96GEZeZSsspDqrubXzuck
         DUXXm+Jxw/p/0xP9Atph6ZbCIOrc4E7iEKFavcTiP8r0rI29yFs4MdI82C1dJhvpqOGK
         /2v7aN9fekT9Dl2kwXvNX5ouI+kmQ6XKxIBpmWB8XiS2dvIP6Annb8vwO7R2MwF9gMdK
         ncag==
Content-Language: en-US
In-Reply-To: <08ec9c4f-80b2-f731-aa8b-fb4e852ece25@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 2022/8/16 22:01, Chengming Zhou wrote:
> On 2022/8/15 21:25, Michal Koutn=C3=BD wrote:
>> On Mon, Aug 08, 2022 at 07:03:31PM +0800, Chengming Zhou <zhouchengming@=
bytedance.com> wrote:
>>> This patch series are some optimization and extension for PSI,
>>
>> BTW do you have some numbers/example how much these modifications save
>> when aggregated together?
>>

Sorry about delay...

Performance test using mmtests/config-scheduler-perfpipe in /user.slice/use=
r-0.slice/session-4.scope

                                 next                patched       patched/=
only-leaf
Min       Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 ( =
  9.32%)
1st-qrtle Time        8.90 (   0.00%)        8.58 (   3.63%)        8.05 ( =
  9.58%)
2nd-qrtle Time        8.94 (   0.00%)        8.61 (   3.65%)        8.09 ( =
  9.50%)
3rd-qrtle Time        8.99 (   0.00%)        8.65 (   3.75%)        8.15 ( =
  9.35%)
Max-1     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 ( =
  9.32%)
Max-5     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 ( =
  9.32%)
Max-10    Time        8.84 (   0.00%)        8.55 (   3.20%)        8.04 ( =
  9.05%)
Max-90    Time        9.04 (   0.00%)        8.67 (   4.10%)        8.18 ( =
  9.51%)
Max-95    Time        9.04 (   0.00%)        8.68 (   4.03%)        8.20 ( =
  9.26%)
Max-99    Time        9.07 (   0.00%)        8.73 (   3.82%)        8.25 ( =
  9.11%)
Max       Time        9.12 (   0.00%)        8.89 (   2.54%)        8.27 ( =
  9.29%)
Amean     Time        8.95 (   0.00%)        8.62 *   3.67%*        8.11 * =
  9.43%*


Thanks!
