From: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Subject: RE: [RFC] memcg: fix default behaviour of non-overridden
 memcg.swappiness
Date: Tue, 14 Apr 2020 16:08:39 +0000
Message-ID: <MN2PR02MB63033A5D2EE11A0D7DFEBE95E9DA0@MN2PR02MB6303.namprd02.prod.outlook.com>
References: <BL0PR02MB560170CD4D4245D4B89BC22EE9F40@BL0PR02MB5601.namprd02.prod.outlook.com>
 <20200320134428.GG24409@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=745c7R5noQJZyZzadl+HjR2ni9lSf396P96eRY/ZhmU=;
 b=03DbJ5drl5HQEVbImtwuqZcW0ICY2uANBQqTHd51+nRFb3fQUFysmvRTXyHkiDBT9ODA
 T1W3arQWw+xGTLTCua1N2RIYz8J51dvfjIHraV+5vDerqTqoHiiJsmdJ7jG1mmCdeTZD
 SbtNbfIr7KfqHOJPFDbO53g391V0VVuDQ7gGQ+uXsbrWe1Ci2/+GXUHkW/hCdvnUmQ2h
 drMRIO9xdvxMe1f1w0q7duViKyWFbttaiX10tmbtWGOz0vGLtK9OE9SW43mrfPXexzCE
 Mk2cpsdjNiobU5NArSmr9iYRglG2/WR/T33gn5hT9xrT42cf/9yk1IukwXWXreZXsZkK 1g== 
In-Reply-To: <20200320134428.GG24409@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: "rientjes@google.com" <rientjes@google.com>, "willy@infradead.org" <willy@infradead.org>, "vbabka@suse.cz" <vbabka@suse.cz>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "guro@fb.com" <guro@fb.com>, "shakeelb@google.com" <shakeelb@google.com>, "chris@chrisdown.name" <chris@chrisdown.name>, "yang.shi@linux.alibaba.com" <yang.shi@linux.alibaba.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "minchan@kernel.org" <minchan@kernel.org>, "ying.huang@intel.com" <ying.huang@intel.com>, "ziqian.lzq@antfin.com" <ziqian.lzq@antfin.com>, cgroups@vger.kerne

On Fri, 20 Mar 2020, Michal Hocko wrote:
> On Thu 19-03-20 17:38:30, Ivan Teterevkov wrote:
> > Also, shall this magic -1 be exposed to the user? I think it's a "no",
> > but what if the user wants to un-override the memcg.swappiness...
>=20
> If we are to use such a semantic then it absolutely has to be an opt-in b=
ehavior
> and expressed in some way to the user space (e.g. a symbolic name referri=
ng to
> the global setting).

A symbolic link would be a good approach but...

> I am not convinced we need it.

... agree and not going any further with the suggestion.

Support of the sysctl parameters in the kernel command line is a
better solution and would address my initially raised concern to
tackle the configuration parameters.

Thanks
Ivan
