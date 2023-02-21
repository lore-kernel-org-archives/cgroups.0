From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Tue, 21 Feb 2023 13:25:59 -0400
Message-ID: <Y/T+pw25oGmKqz1k@nvidia.com>
References: <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
 <CAJD7tka6SC1ho-dffV0bK_acoZd-5DQzBOy0xg3TkOFG1zAPMg@mail.gmail.com>
 <Y+GMbWWP/YhtJQqe@slm.duckdns.org>
 <Y+GQB9I6MFN6BOFw@nvidia.com>
 <Y+GcJQRhvjqFaaSp@mtj.duckdns.org>
 <Y+0rxoM4w9nilUMZ@dhcp22.suse.cz>
 <Y+0tWZxMUx/NZ3Ne@nvidia.com>
 <Y+3jcw9vo4ml5p0M@dhcp22.suse.cz>
 <Y+4lcq4Fge27TQIn@nvidia.com>
 <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u21dPGAbr4FZY8ULU33FW37RRHqX2D336jNdYJyMEGU=;
 b=CHoM6+4y8fE5A6zIiGgWag/qgOHuGQEneMEUkh0/59Neh1lJm559dg/06YtIPti5LW+hliggr0Lu1Vnq0VX9yajkTGRVjmbN/fDNyk100TYLDMhgG5obYf03llM4d+Y0e5IkNWt4sKlx5+jRnTotjceO6AF0v1BSHRj3zmvL65j6pvnuXi/IXRG4XDg5rl4TIUGqfRZWzTaed26DNLhXcZZ1aBrYdSm4bHKYuWfLBGy1xDNxGyeMS7usDaX24bQQkHlHybIHg5Qy4vbLpjgn3JxoFemjoQbcMcJbcX6P3jsxlI2zjLFFpir+FhNqaTAv9sLfUH7xcxCn0gkUlc7h0A==
Content-Disposition: inline
In-Reply-To: <Y/T2pNQ70eMAl1sX@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Yosry Ahmed <yosryahmed@google.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Tue, Feb 21, 2023 at 06:51:48AM -1000, Tejun Heo wrote:
> cgroup, right? It makes little sense to me to separate the owner of the
> memory page and the pinner of it. They should be one and the same.

The owner and pinner are not always the same entity or we could just
use the page's cgroup.

Jason
