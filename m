From: Matteo Croce <mcroce@redhat.com>
Subject: Re: WARNING: CPU: 1 PID: 228 at kernel/cgroup/cgroup.c:5929
Date: Tue, 14 May 2019 21:54:46 +0200
Message-ID: <CAGnkfhxwP1SwJLv2E-6Xd7ZXN8XUPRyXkM=tB0Z=jre8Rij6=A@mail.gmail.com>
References: <CAGnkfhwMSNm4uSkcGtqaGmYanfNK9rx6m2a3TqJh08YitbGAUg@mail.gmail.com>
 <20190514194249.GD12629@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514194249.GD12629@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

Hi Roman,

yes, this one fixes it.

-- 
Matteo Croce
per aspera ad upstream
